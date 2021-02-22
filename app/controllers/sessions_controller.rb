class SessionsController < ApplicationController

  # --------- Filters ------------------------------------------------------
  skip_before_action :restricted_to_logged_in_almighty_only

  # --------- Action methods -----------------------------------------------
  def index
    redirect_to(accounts_path) if current_almighty
  end

  def create
    almighty = Almighty.find_by_email(params[:email].try(:strip).try(:downcase))
    if (almighty and almighty.authenticate(params[:password]))
      make_session(almighty)
      redirect_to(accounts_path, notice: "Welcome #{current_almighty.name}") and return
    else
      redirect_to(root_path, notice: "Invalid credentials! You may please try again.") and return
    end
  end

  def destroy
    clear_session
    redirect_to root_path
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

  private

  def make_session(almighty)
    clear_session
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
