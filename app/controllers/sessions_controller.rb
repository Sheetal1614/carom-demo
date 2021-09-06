class SessionsController < ApplicationController

  # --------- Layout -------------------------------------------------------
  layout 'okta', only: [:okta_login]

  # --------- Filters ------------------------------------------------------
  skip_before_action :restricted_to_logged_in_almighty_only

  # --------- Action methods -----------------------------------------------
  def index
    redirect_to okta_login_session_path unless current_almighty
  end

  def login
  end

  def okta_login
    if request.post?
      response_json, response_code, response = FennelNegotiator.current_user(params[:fennel_token])
      if response_code.to_s =~ /2[0-9]{2}/i

        user = if (_user = User.where(fmno: response_json.dig('user', 'fmno')).take)
                 _user
               else
                 _user = User.new(response_json.dig('user').select {|k, v| ['fmno', 'email', 'name'].include?(k)})
                 if _user.save
                   _user
                 else
                   Rails.logger.debug(_user.errors.inspect)
                   nil
                 end
               end

        _shift_to = if user.is_a?(User)
                      make_session_and_traverse_to(user)
                    else
                      flash[:notice] = "Unable to provision user from Okta. Let's try other means to login."
                      login_session_path
                    end

        render(json: {shift_to: _shift_to}) and return
      else
        raise "Unable to get valid(2xx) instead received #{response_code} response from Fennel"
      end
    else
      @fennel_account_detail = FennelNegotiator.new.account_details
    end
  end

  def create
    almighty = Almighty.find_by_email(params[:email].try(:strip).try(:downcase))
    if (almighty and almighty.authenticate(params[:password]))
      redirect_to(make_session_and_traverse_to(almighty)) and return
    else
      redirect_to(login_session_path, notice: "Invalid credentials! You may please try again.") and return
    end
  end

  def destroy
    clear_session
    redirect_to(login_session_path)
  end

  def sign_up
    if request.get?
      @almighty = Almighty.new
    elsif request.post?
      almighty = Almighty.new(almighty_params)
      if almighty.save
        make_session(almighty)
        redirect_to(accounts_path, notice: "Welcome #{current_almighty.name}") and return
      else
        Rails.logger.debug almighty.errors.inspect
        @almighty = almighty
      end
    end
  end

  def renew_fennel_access_token
    Rails.cache.delete(FennelNegotiator.cache_key_4_access_token) # Will enforce renewal of Fennel's access token, on next request.
  end

  private

  def make_session_and_traverse_to(almighty)
    make_session(almighty)
    (cookies.delete(:redirect_to_after_login) || accounts_path)
  end

  def make_session(almighty)
    clear_session
    flash[:notice] = "Welcome #{almighty.name}"
    session[:almighty_id] = almighty.id
  end

  def clear_session
    session[:almighty_id] = nil
    @current_almighty = nil
    reset_session
  end

  def almighty_params
    params.require(:almighty).permit(:name, :email, :password, :password_confirmation)
  end

end
