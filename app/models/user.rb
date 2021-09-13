class User < ApplicationRecord

  # --------- Constants ----------------------------------------------------
  NON_DEVELOPMENT_ENVIRONMENTS = %w(production qa)
  DEFAULT_PA55W0RD = Base64.decode64("V2VsY29tZUAxMjM")

  # --------- For password store using bcrypt ------------------------------
  has_secure_password

  # --------- Associations -------------------------------------------------
  has_many :memberships, inverse_of: :user, dependent: :destroy
  has_many :teams, through: :memberships

  has_many :leading_memberships, -> {where(kind: Membership::MT_TEAM_LEADER)}, class_name: 'Membership', dependent: :destroy
  has_many :leading_teams, through: :leading_memberships, source: :team

  # --------- Validations --------------------------------------------------
  validate :check_for_lone_application_admin
  validates :name, presence: true
  validates :fmno, presence: true, uniqueness: {case_sensitive: false}, format: {with: /\A[0-9]+\z/i, message: 'can only contain numbers'}
  validates :email, presence: true, uniqueness: {case_sensitive: false}

  # --------- Scopes -------------------------------------------------------
  scope :application_admins, -> {where(application_admin: true)}

  # --------- Callbacks ----------------------------------------------------
  before_validation :strip_fmno
  before_validation :fix_garbage_email
  before_validation :strip_email
  before_validation :provision_default_password

  # --------- Instance methods ---------------------------------------------

  def email_with_name
    "#{self.name} <#{self.email}>"
  end

  def brief
    attributes.select {|k| %w(id fmno email name created_at updated_at).include?(k)} rescue nil
  end

  private

  #As it is garbage data (in integration)
  def fix_garbage_email
    return if NON_DEVELOPMENT_ENVIRONMENTS.include?(Rails.env)

    self.email = "#{self.fmno}@test.mckinsey.com"
  end

  def strip_fmno
    self.fmno = fmno.try(:strip).try(:downcase)
  end

  def strip_email
    self.email = email.try(:strip).try(:downcase)
  end

  def provision_default_password
    if self.new_record? and (not self.password)
      self.password = self.password_confirmation = User::DEFAULT_PA55W0RD
    end
  end

  # Makes at least one application admin present in application by checking
  # 1. user is an existing record
  # 2. Its admin changed to false
  # 3. and no other user exists with application admin value
  def check_for_lone_application_admin
    if (not self.new_record?) and self.application_admin_changed? and self.application_admin_was == true and (not User.application_admins.where.not(id: self.id).exists?)
      errors.add(:base, "can't remove the only application admin in the application")
    end
  end

end