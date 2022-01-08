# Documentation: https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html
class Current < ActiveSupport::CurrentAttributes

  # --------- Attributes ---------------------------------------------------
  attribute :account, :user
  # attribute :request_id, :user_agent, :ip_address

  # --------- Callbacks ----------------------------------------------------
  # resets { Time.zone = nil }

  # def user=(user)
  #   super
  #   self.account = user.account
  #   Time.zone    = user.time_zone
  # end

end