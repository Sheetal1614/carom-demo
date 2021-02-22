class Almighty < ApplicationRecord

  # --------- Associations -------------------------------------------------
  has_many :accounts, inverse_of: :almighty
  has_many :pokes, through: :accounts

  # --------- For password store using bcrypt ------------------------------
  has_secure_password

  # --------- Validations --------------------------------------------------
  validates :email, uniqueness: {case_sensitive: false}

  # --------- Callbacks ----------------------------------------------------
  before_validation :strip_email

  # --------- Instance methods ---------------------------------------------

  private

  def strip_email
    self.email = email.try(:strip).try(:downcase)
  end

end
