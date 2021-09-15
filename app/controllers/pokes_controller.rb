class PokesController < ApplicationController

  # --------- Filters ------------------------------------------------------
  before_action :fetch_team
  before_action :fetch_poke, only: [:update, :destroy]

  def index
  end

  def create
    @poke = @team.pokes.new(poke_params)
    _notice = if @poke.save
                @poke.do(true)
                "Poke created successfully."
              else
                "Failed to create poke as #{@poke.errors.full_messages.to_sentence}"
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
    return if (@poke = current_user.accessible_pokes.where(id: params[:id]).take)
    redirect_on_inaccessible_poke
  end

  def fetch_team
    return if (@team = current_user.teams.where(id: params[:team_id]).take)
    redirect_on_inaccessible_team
  end

end
