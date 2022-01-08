class SessionsController < ApplicationController

  # --------- Layout -------------------------------------------------------
  layout 'okta', only: [:okta_login]

  # --------- Filters ------------------------------------------------------
  skip_before_action :restricted_to_logged_in_user_only
  before_action :available_only_when_signup_is_open, only: [:sign_up]

  # --------- Action methods -----------------------------------------------
  def index
    redirect_to okta_login_session_path unless Current.user
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

  def login
  end

  def create
    user = User.where(["fmno = ? or email = ?", params[:email].try(:strip).try(:downcase), params[:email].try(:strip).try(:downcase)]).take
    if (user and user.authenticate(params[:password]))
      redirect_to(make_session_and_traverse_to(user)) and return
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
      @user = User.new
    elsif request.post?
      user = User.new(user_params)
      if user.save
        redirect_to(make_session_and_traverse_to(user)) and return
      else
        Rails.logger.debug user.errors.inspect
        flash[:notice] = flash.now[:notice] = "Failed to create User because, #{user.errors.full_messages.to_sentence}"
        @user = user
      end
    end
  end

  def renew_fennel_access_token
    Rails.cache.delete(FennelNegotiator.cache_key_4_access_token) # Will enforce renewal of Fennel's access token, on next request.
  end

  private

  def make_session_and_traverse_to(user)
    make_session(user)
    (cookies.delete(:redirect_to_after_login) || root_path)
  end

  def make_session(user)
    clear_session

    flash[:notice] = "Welcome #{user.name}"
    session[:user_id] = user.id
    populate_current_user
  end

  def clear_session
    Current.user = session[:user_id] = nil
    reset_session
  end

  def user_params
    params.require(:user).permit(:name, :fmno, :email, :password, :password_confirmation)
  end

  def available_only_when_signup_is_open
    redirect_to(login_session_path, notice: "Sign-up is closed. Get in touch with 'Application admin' to open Sign-up.") unless signup_enabled?
  end

end
