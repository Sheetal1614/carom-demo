class Poke < ApplicationRecord

  # --------- Constants ----------------------------------------------------
  # For cron expression refer: https://www.freeformatter.com/cron-expression-generator-quartz.html
  CRON_HELP = <<EOF
Field name     Mandatory?   Allowed values    Allowed special characters
----------     ----------   --------------    --------------------------
Seconds        No           0-59              * / , -
Minutes        Yes          0-59              * / , -
Hours          Yes          0-23              * / , -
Day of month   Yes          1-31              * / , - L W
Month          Yes          1-12 or JAN-DEC   * / , -
Day of week    Yes          0-6 or SUN-SAT    * / , - L #
Year           No           1970–2099         * / , -
EOF

  CRON_FIELDS = {cron_seconds: '0', cron_minutes: '*', cron_hours: '*', cron_day_of_month: '*', cron_month: '*', cron_day_of_week: '*', cron_year: '*'}
  RESPONSE = 'RESPONSE'
  EXCEPTION = 'EXCEPTION'
  INACTIVE = 'inactive'

  # --------- Stored attributes --------------------------------------------
  store :other_attributes,
        accessors: ([:url, :validating_uuid, :latest_responses] + CRON_FIELDS.keys),
        coder: JSON

  # --------- Associations -------------------------------------------------
  belongs_to :team, inverse_of: :pokes

  # --------- Validations --------------------------------------------------
  validates :frequency, presence: true
  validates :url, presence: true,
            format: {with: /\Ahttps?:\/\/(.*\.intranet\.mckinsey\.com|[\w]{1,}|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(:\d+)?(\S*)\z/i,
                     message: 'should be valid McKinsey intranet(or host or ip address with/out port) url starting with http/https.'}
  validates :validating_uuid, presence: true

  # --------- Callbacks ----------------------------------------------------
  after_initialize do
    self.latest_responses ||= []
    CRON_FIELDS.each do |field_name, default_value|
      self.send("#{field_name}=", default_value) if self.send("#{field_name}").blank?
    end
  end

  before_validation :try_populating_cron_fields
  before_validation :try_populating_frequency
  before_validation :try_populating_validating_uuid
  before_validation :try_trimming_latest_responses

  before_save :allow_for_team_leaders_only
  before_destroy :allow_for_team_leaders_only

  after_commit :refresh_crontab_file, on: [:create, :update, :destroy]

  def refresh_crontab_file
    `rake carom:provision_cron`
  end

  # --------- Instance methods ---------------------------------------------
  def do(force = false, manual_call = false)
    if force or doable?
      Rails.logger.debug("Executing poke: #{['id', 'live', 'url', 'validating_uuid'].collect {|_method| {_method => self.send(_method)}}.inject(&:merge)}}")
      begin
        _response = Faraday.new(url: self.url, headers: {'user-agent': "Carom (Faraday gem -v #{`gem -v faraday`.try(:chomp)})",
                                                         'content-type': 'application/json',
                                                         'http-referrer': 'Carom poke',
                                                         'Validating-Uuid': self.validating_uuid}).post do |req|
          # req.body = params.to_json
        end

        (self.latest_responses ||= []).prepend([Time.now, RESPONSE, _response.headers["validating-uuid"], _response.status, _response.body])
      rescue Exception => e
        (self.latest_responses ||= []).prepend([Time.now, EXCEPTION, e.message, e.backtrace])
      end

      try_trimming_latest_responses(25)

      self.update_columns(other_attributes: self.other_attributes)

      unless doable?
        NotificationMailer.notify_team_members_for_inactive_poke(self).deliver_later if self.live and (not manual_call)
        self.update_columns(live: false)
      end
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

  def try_populating_frequency
    self.frequency = CRON_FIELDS.keys.collect {|_field| self.send(_field).to_s.strip}.join(" ")
  end

  def try_populating_cron_fields
    CRON_FIELDS.each do |field_name, default_value|
      self.send("#{field_name}=", default_value) if self.send("#{field_name}").blank?
    end
  end

  def try_populating_validating_uuid
    self.validating_uuid ||= SecureRandom.uuid
  end

  #Only persist last 20 responses
  def try_trimming_latest_responses(last_n_responses = 20)
    self.latest_responses = self.latest_responses[0...last_n_responses]
  end

  def allow_for_team_leaders_only
    # return if RequestInfo.current_user and RequestInfo.current_user.leading_pokes.where(id: self.id).exists?
    # if _current_user = RequestInfo.current_user and _team = _current_user.teams.where(id: self.team_id).take and _team.team_leaders.include?(RequestInfo.current_user)
    # else
    return if RequestInfo.current_user and self.team.team_leaders.include?(RequestInfo.current_user)

    self.errors.add(:base, "not accessible for the operation. Only team leaders are allowed for create, update & delete operations.")
    throw(:abort)
  end

end
