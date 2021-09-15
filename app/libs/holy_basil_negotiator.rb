gem 'ThymeFieldAccommodator'

class HolyBasilNegotiator < ThymeFieldAccommodator::Negotiator

  def initialize
    @account_details = Rails.application.config.holy_basil_connector
    super
  end

  class << self
    def firm_members(search_criteria = {})
      place({
                method: :get,
                url: "api/v1/wrappers/firm_members.json",
                params: {
                    search_criteria: search_criteria
                }
            })
    end

    def firm_members_by_name(name)
      firm_members({name: name})
    end
  end

end