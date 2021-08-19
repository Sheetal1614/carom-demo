class PokesController < ApplicationController

  # --------- Filters ------------------------------------------------------
  before_action :fetch_poke, only: [:update, :destroy]

  def create
    @account = current_almighty.accounts.where(id: params[:account_id]).take

    _notice = if @account
                @poke = @account.pokes.new(poke_params)
                if @poke.save
                  @poke.do(true)
                  "Poke created successfully."
                else
                  "Failed to create poke as #{@poke.errors.full_messages.to_sentence}"
                end
              else
                redirect_on_inaccessible_poke(_message = "Account doesn't exist or is not accessible for the operation.") and return
              end

    flash[:notice] = flash.now[:notice] = _notice if _notice
  end

  def update
    _notice = if @poke.update(poke_params)
                @poke.do(true)
                "Poke updated successfully."
              else
                "Failed to update poke as #{@poke.errors.full_messages.to_sentence}"
              end

    flash.now[:notice] = _notice if _notice
  end

  def destroy
    _notice = if @poke.destroy
                "Poke deleted successfully."
              else
                "Failed to delete poke as #{@poke.errors.full_messages.to_sentence}"
              end

    flash.now[:notice] = _notice if _notice
  end

  private

  def poke_params
    params.require(:poke).permit(:live, :url, *Poke::CRON_FIELDS.keys)
  end

  def fetch_poke
    return if (@poke = current_almighty.pokes.where(id: params[:id]).take)
    redirect_on_inaccessible_poke
  end

  def redirect_on_inaccessible_poke(_message = "Either poke doesn't exist or is not accessible for the operation.")
    _redirect_to_path = accounts_path

    if request.xhr?
      flash[:notice] = _message
      render js: "window.location = '#{_redirect_to_path}'"
    else
      redirect_to(_redirect_to_path, notice: _message)
    end
  end

end
