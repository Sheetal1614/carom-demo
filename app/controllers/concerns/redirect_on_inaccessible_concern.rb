module RedirectOnInaccessibleConcern
  extend ActiveSupport::Concern

  # --------- Constants ----------------------------------------------------
  MESSAGE_INACCESSIBLE_POKE = "Either poke doesn't exist or is not accessible for the operation."
  MESSAGE_INACCESSIBLE_TEAM = "Either team doesn't exist or is not accessible for the operation."

  included do
  end

  class_methods do
    # ....
  end

  def redirect_on_inaccessible_poke
    redirect_on_inaccessible(MESSAGE_INACCESSIBLE_POKE)
  end

  def redirect_on_inaccessible_team
    redirect_on_inaccessible(MESSAGE_INACCESSIBLE_TEAM)
  end

  def redirect_on_inaccessible(_message)
    _redirect_to_path = if Current.user.teams.exists?
                          members_team_path(Current.user.teams.first)
                        else
                          root_path
                        end

    if request.xhr?
      flash[:notice] = _message
      render js: "window.location = '#{_redirect_to_path}'"
    else
      redirect_to(_redirect_to_path, notice: _message)
    end
  end

end