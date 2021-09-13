class ApplicationController < ActionController::Base

  # --------- Constants ----------------------------------------------------
  LABEL_SIGNUP_ENABLED = 'signup_enabled'

  # --------- Module inclusions --------------------------------------------
  include RequestInfo

  # --------- Filters ------------------------------------------------------
  skip_before_action :verify_authenticity_token
  before_action :populate_current_user
  before_action :restricted_to_logged_in_user_only
  before_action do
    Rails.logger.debug "REQUEST_OBJECT (ApplicationController): #{request.inspect}"
  end

  # --------- Helpers ------------------------------------------------------
  helper_method :current_user, :signup_enabled?

  def signup_enabled?
    (Rails.cache.read(LABEL_SIGNUP_ENABLED) || false)
  end

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
