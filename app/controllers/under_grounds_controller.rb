class UnderGroundsController < ApplicationController

  # --------- Module inclusions --------------------------------------------
  include ActionView::Helpers::TextHelper

  # --------- Filters ------------------------------------------------------
  before_action :restricted_to_application_admin_only

  # --------- Actions ------------------------------------------------------
  def teams
    return if request.method == 'GET'

    @team = Team.where(id: params[:team_id]).take

    flash.now[:notice] = @flash_notice = if @team
                                           if params[:action_2_perform] == 'update'
                                             if (@result = @team.update(team_params))
                                               "Team updated successfully."
                                             else
                                               "Update failed because of #{@team.errors.full_messages.to_sentence}"
                                             end
                                           elsif params[:action_2_perform] == 'delete'
                                             if (@result = @team.destroy)
                                               "Team removed."
                                             else
                                               "Failed to delete because of #{@team.errors.full_messages.to_sentence}"
                                             end
                                           else
                                             'Invalid action to perform.'
                                           end
                                         elsif params[:action_2_perform] == 'add'
                                           _team_leaders = (params[:fmnos_with_name_and_email] || []).uniq.collect do |fmno_with_name_and_email|
                                             _matched_data = fmno_with_name_and_email.match(/(.+) \(name: (.*)\) \(email: (.*)\)\z/i)

                                             member = User.find_or_initialize_by(fmno: _matched_data[1])

                                             if member.new_record?
                                               member.name = (_matched_data[2].present? ? _matched_data[2] : nil)
                                               member.email = (_matched_data[3].present? ? _matched_data[3] : nil)
                                             end

                                             member
                                           end

                                           _team = Team.new(team_params)

                                           if (@result = _team.save)
                                             _team.team_leaders = _team_leaders
                                             "Team: '#{_team.name}' created successfully."
                                           else
                                             "Failed to create team because, #{_team.errors.full_messages.to_sentence}."
                                           end
                                         else
                                           'Team not found.'
                                         end
  end

  def application_admins
    if request.xhr?

      flash[:notice] = if params[:action_2_perform] == 'add'
                         _members = (params[:fmnos_with_name_and_email] || []).uniq.collect do |fmno_with_name_and_email|
                           _matched_data = fmno_with_name_and_email.match(/(.+) \(name: (.*)\) \(email: (.*)\)\z/i)

                           member = User.find_or_initialize_by(fmno: _matched_data[1])

                           if member.new_record?
                             member.name = (_matched_data[2].present? ? _matched_data[2] : nil)
                             member.email = (_matched_data[3].present? ? _matched_data[3] : nil)
                           end

                           member.application_admin = true

                           member
                         end

                         success_count = 0
                         failed_count = 0

                         _members.each do |member|
                           if member.save
                             success_count += 1
                           else
                             Rails.logger.debug(member.errors.inspect)
                             failed_count += 1
                           end
                         end

                         messages = []
                         messages << "Successfully added #{pluralize(success_count, 'application admin')}"
                         messages << "while #{failed_count} failed" if failed_count > 0

                         messages.join(' ')
                       elsif params[:action_2_perform] == 'remove'
                         if (user = User.application_admins.where(id: params[:user_id]).take)
                           if user.update(application_admin: false)
                             'Application admin removed.'
                           else
                             Rails.logger.debug(user.errors.inspect)
                             "Failed to remove application admin because, #{user.errors.full_messages.to_sentence}."
                           end
                         else
                           'Application admin not found.'
                         end
                       else
                         'Invalid action to perform.'
                       end
    end
  end

  def miscellaneous
    if request.xhr?

      _notice = if params[:action_2_perform] == "toggle_signup"

                  if Rails.cache.exist?(LABEL_SIGNUP_ENABLED)
                    Rails.cache.delete(LABEL_SIGNUP_ENABLED)
                    "Sign up switched off."
                  else
                    Rails.cache.write(LABEL_SIGNUP_ENABLED, Time.now, expires_in: 10.minutes)
                    "Sign up switched on for next 10 mins."
                  end

                 else
                  "Invalid action to perform"
                end

      flash.now[:notice] = _notice if _notice
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def restricted_to_application_admin_only
    unless Current.user.application_admin?
      _message = "Access restricted. Only application's admin are passed through."

      if request.xhr?
        flash[:notice] = _message
        render js: "window.location = '#{root_url}'"
      else
        redirect_to(root_path, notice: _message)
      end
    end
  end

end