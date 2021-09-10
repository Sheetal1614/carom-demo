module RedirectOnInaccessibleConcern
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    # ....
  end

  def redirect_on_inaccessible_poke
    _message = "Either poke doesn't exist or is not accessible for the operation."
    redirect_on_inaccessible(_message)
  end

  def redirect_on_inaccessible_team
    _message = "Either team doesn't exist or is not accessible for the operation."
    redirect_on_inaccessible(_message)
  end

  def redirect_on_inaccessible(_message)
    _redirect_to_path = if current_user.teams.exists?
                          members_team_path(current_user.teams.first)
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