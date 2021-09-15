module CurrentUserAccessRestriction

  # --------- Module inclusions --------------------------------------------
  include RequestInfo

  private

  def restricted_to_logged_in_user_only
    return if current_user

    cookies[:redirect_to_after_login] = request.path
    redirect_to(root_path, notice: 'Restricted access. Please login')
  end

  def populate_current_user
    RequestInfo.current_user = if session[:user_id]
                                 User.where(id: session[:user_id]).take
                               else
                                 nil
                               end
  end

end