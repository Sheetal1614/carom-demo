gem 'ThymeFieldAccommodator'

class FennelNegotiator < ThymeFieldAccommodator::Negotiator

  def initialize
    @account_details = Rails.application.config.fennel_connector
    super
  end

  class << self
    def current_user(fennel_token)
      place({
                method: :get,
                url: "api/v1/sessions/user.json",
                params: {
                    fennel_token: fennel_token
                }
            })
    end
  end

end