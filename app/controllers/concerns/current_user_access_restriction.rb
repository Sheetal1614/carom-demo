module CurrentUserAccessRestriction

  private

  def restricted_to_logged_in_user_only
    return if Current.user

    cookies[:redirect_to_after_login] = request.path
    redirect_to(root_path, notice: 'Restricted access. Please login')
  end

  def populate_current_user
    Current.user = if session[:user_id]
                     User.where(id: session[:user_id]).take
                   else
                     nil
                   end
  end

end