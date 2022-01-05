class ApplicationController < ActionController::Base

  # --------- Constants ----------------------------------------------------
  LABEL_SIGNUP_ENABLED = 'signup_enabled'

  # --------- Module inclusions --------------------------------------------
  include CurrentUserAccessRestriction
  include RedirectOnInaccessibleConcern

  # --------- Filters ------------------------------------------------------
  skip_before_action :verify_authenticity_token
  before_action :populate_current_user
  before_action :restricted_to_logged_in_user_only

  # --------- Helpers ------------------------------------------------------
  helper_method :signup_enabled?

  def signup_enabled?
    (Rails.cache.read(LABEL_SIGNUP_ENABLED) || false)
  end

end
