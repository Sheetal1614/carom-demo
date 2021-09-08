class AccountsController < ApplicationController

  # --------- Filters ------------------------------------------------------
  before_action :fetch_account, only: [:show]

  def index
    @accounts = current_user.accounts.order('id desc')
  end

  def show
  end

  def create
    message = if (team = current_user.leading_teams.where(id: params.dig(:account, :team_id)).take)
                account = team.accounts.new(account_params)

                if account.save
                  'Account created.'
                else
                  "Failed to create account because, #{account.errors.full_messages.to_sentence}"
                end
              else
                'Team not found.'
              end

    redirect_to accounts_path, notice: message
  end

  private

  def account_params
    params.require(:account).permit(:name)
  end

  def fetch_account
    return if (@account = current_user.accounts.where(id: params[:id]).take)

    message = "Either account doesn't exist or is not accessible for the operation."
    if request.xhr?
      flash[:notice] = message
      render(js: "window.location = '#{accounts_path}'; ")
    else
      redirect_to(accounts_path, notice: message)
    end
  end

end
