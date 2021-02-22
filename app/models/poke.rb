class Poke < ApplicationRecord

  # --------- Constants ----------------------------------------------------
  FREQUENCY_SET = {
      'Every 15 seconds' => '*/15 * * * * * *',
      'Every 30 seconds' => '*/30 * * * * * *',
      'Every 45 seconds' => '*/45 * * * * * *',
      'Every minute' => '*/1 * * * *'
  }
  RESPONSE = 'RESPONSE'
  EXCEPTION = 'EXCEPTION'

  # --------- Stored attributes --------------------------------------------
  store :other_attributes,
        accessors: [:url, :validating_uuid, :latest_responses],
        coder: JSON

  # --------- Associations -------------------------------------------------
  belongs_to :account, inverse_of: :pokes

  # --------- Validations --------------------------------------------------
  validates :frequency, presence: true, inclusion: {in: FREQUENCY_SET.keys.collect(&:to_s)}
  validates :url, presence: true,
            format: {with: /\Ahttps?:\/\/(.*\.intranet\.mckinsey\.com|[\w]{1,}|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(:\d+)?(\S*)\z/i,
                     message: 'should be valid McKinsey intranet(or host or ip address with/out port) url starting with http/https.'}
  validates :validating_uuid, presence: true

  # --------- Callbacks ----------------------------------------------------
  after_initialize do
    self.latest_responses ||= []
  end
  before_validation :try_populating_validating_uuid
  before_validation :try_trimming_latest_responses

  # --------- Instance methods ---------------------------------------------
  def do(force = false)
    if force or doable?
      Rails.logger.debug("Executing poke: #{['id', 'live', 'url', 'validating_uuid'].collect {|_method| {_method => self.send(_method)}}.inject(&:merge)}}")
      begin
        _response = Faraday.new(url: self.url, headers: {'content-type': 'application/json', 'Validating-Uuid': self.validating_uuid}).post do |req|
          # req.body = params.to_json
        end

        (self.latest_responses ||= []).prepend([Time.now, RESPONSE, _response.headers["validating-uuid"], _response.status, _response.body])
      rescue Exception => e
        (self.latest_responses ||= []).prepend([Time.now, EXCEPTION, e.message, e.backtrace])
      end
      self.save

      self.update_columns(live: false) unless doable?
    end
  end

  def doable?
    return true if (self.latest_responses.blank? or
        (self.latest_responses.dig(0, 1) == RESPONSE and
            self.latest_responses.dig(0, 2) == self.validating_uuid and
            self.latest_responses.dig(0, 3).to_s =~ /2[0-9]{2}/i))

    false
  end

  private

  def try_populating_validating_uuid
    self.validating_uuid ||= SecureRandom.uuid
  end

  #Only persist last 20 responses
  def try_trimming_latest_responses(last_n_responses = 20)
    self.latest_responses = self.latest_responses[0...last_n_responses]
  end

end
