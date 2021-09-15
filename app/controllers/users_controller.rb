class UsersController < ApplicationController

  def profile
    @user = current_user
  end

  def update
    @user = current_user

    flash.now[:notice] = if @user.authenticate(params.dig(:user, :existing_password))
                           if @user.update(user_params)
                             'Password changed successfully.'
                           else
                             "Failed to update because of #{@user.errors.full_messages.to_sentence}"
                           end
                         else
                           'Invalid current password'
                         end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
