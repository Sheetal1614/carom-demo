class TeamsController < ApplicationController

  # --------- Filters ------------------------------------------------------
  before_action :fetch_team, only: [:members]
  before_action :fetch_leading_team, only: [:toggle_team_leader, :remove_member]

  def members
    if request.xhr?
      unless current_user.leading_teams.where(id: params[:id]).take
        flash[:notice] = RedirectOnInaccessibleConcern::MESSAGE_INACCESSIBLE_TEAM
        return
      end

      (params[:fmnos_with_name_and_email] || []).uniq.collect do |fmno_with_name_and_email|
        _matched_data = fmno_with_name_and_email.match(/(.+) \(name: (.*)\) \(email: (.*)\)\z/i)

        member = User.find_or_initialize_by(fmno: _matched_data[1])

        if member.new_record?
          member.name = (_matched_data[2].present? ? _matched_data[2] : nil)
          member.email = (_matched_data[3].present? ? _matched_data[3] : nil)

          unless member.save
            Rails.logger.debug(member.errors.inspect)
          end
        end

        if (not member.new_record?) and (not @team.team_members.exists?(id: member.id))
          @team.team_members << member
        end
      end
    end
  end

  def toggle_team_leader
    @member = @team.team_members.where(id: params[:member_id]).take

    flash.now[:notice] = if @member
                           if @team.team_leaders.where(id: params[:member_id]).exists?
                             if @team.team_leaders.destroy(@member)
                               @team.team_members << @member

                               'Revoked team leader access.'
                             else
                               'Failed to revoke team leader access.'
                             end
                           else
                             @team.team_members.destroy(@member)
                             @team.team_leaders << @member
                             'Granted team leader access.'
                           end
                         else
                           "Team member not found."
                         end
  end

  def remove_member
    _member = @team.team_members.where(id: params[:member_id]).take

    flash[:notice] = if _member
                       _message = if @team.team_leaders.where(id: params[:member_id]).exists?
                                    if @team.team_leaders.destroy(_member)
                                      'Removed team leader.'
                                    else
                                      'Failed to remove team leader.'
                                    end
                                  elsif @team.team_members.where(id: params[:member_id]).exists?
                                    if @team.team_members.destroy(_member)
                                      'Removed team member.'
                                    else
                                      'Failed to remove team member.'
                                    end
                                  end

                       # Destroy the member too if he/she is not an application_admin and doesn't belong to any team
                       _member.destroy if (not _member.application_admin?) and _member.teams.blank?

                       _message
                     else
                       'Team member not found.'
                     end
  end

  private

  def fetch_team
    return if (@team = current_user.teams.where(id: params[:id]).take)
    redirect_on_inaccessible_team
  end

  def fetch_leading_team
    return if (@team = current_user.leading_teams.where(id: params[:id]).take)
    redirect_on_inaccessible_team
  end

end
