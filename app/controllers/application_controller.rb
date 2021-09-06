class ApplicationController < ActionController::Base

  # --------- Filters ------------------------------------------------------
  skip_before_action :verify_authenticity_token
  before_action :restricted_to_logged_in_almighty_only
  before_action do
    Rails.logger.debug "REQUEST_OBJECT (ApplicationController): #{request.inspect}"
  end

  # --------- Helpers ------------------------------------------------------
  helper_method :current_almighty

  def current_almighty
    @current_almighty ||= if session[:almighty_id]
                        Almighty.where(id: session[:almighty_id]).take
                      end
  end

  private

  def restricted_to_logged_in_almighty_only
    return if current_almighty

    cookies[:redirect_to_after_login] = request.path
    redirect_to(root_path, notice: 'Restricted access. Please login')
  end

end
