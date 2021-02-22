class AccountsController < ApplicationController

  # --------- Filters ------------------------------------------------------
  before_action :fetch_account, only: [:show]

  def index
    @accounts = current_almighty.accounts.order('id desc')
  end

  def show
  end

  def create
    account = current_almighty.accounts.new(account_params)
    message = if account.save
                'Account created.'
              else
                Rails.logger.debug(account.errors.inspect)
                'Failed to create account.'
              end

    redirect_to accounts_path, notice: message
  end

  private

  def account_params
    params.require(:account).permit(:name)
  end

  def fetch_account
    return if (@account = current_almighty.accounts.includes(:pokes).where(id: params[:id]).take)
    redirect_on_inaccessible_account
  end

  def redirect_on_inaccessible_account
    _message = "Either account doesn't exist or is not accessible for the operation."
    _redirect_to_path = accounts_path

    if request.xhr?
      flash[:notice] = _message
      render js: "window.location = '#{_redirect_to_path}'"
    else
      redirect_to(_redirect_to_path, notice: _message)
    end
  end

end
