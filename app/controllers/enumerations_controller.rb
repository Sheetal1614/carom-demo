class EnumerationsController < ApplicationController

  def people
    @options_set = []

    return if params[:term].blank?
    response, response_code = HolyBasilNegotiator.firm_members_by_name(params[:term])

    if response_code == 200
      begin
        @options_set = (response.dig("response", "persons") || []).collect do |person_hash|
          {
              full_name: _full_name = [
                  (person_hash.dig('core', 'preferredName') || person_hash.dig('core', 'firstName')),
                  person_hash.dig('core', 'lastName')
              ].compact.join(' ').strip,

              id: if params[:combine_name_and_fmno]
                    "#{person_hash.dig('core', 'fmno')} (name: #{_full_name})"
                  elsif params[:combine_name_email_and_fmno]
                    "#{person_hash.dig('core', 'fmno')} (name: #{_full_name}) (email: #{person_hash.dig('contact', 'emails', 0, 'emailAddress')})"
                  else
                    person_hash.dig('core', 'fmno')
                  end,

              text: [
                  _full_name,
                  "(#{person_hash.dig('hr', 'careerTitle')})",
                  "- #{person_hash.dig('core', 'fmno')}"
              ].compact.join(' ').strip
          }
        end
      rescue => e
        ExceptionNotifier.notify_exception(e, data: {user: self, from_holy_basil: {response_body: response, response_code: response_code}})
      ensure
        @options_set
      end
    end
  end

end
