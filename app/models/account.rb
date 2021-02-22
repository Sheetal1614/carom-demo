class Account < ApplicationRecord

  # --------- Associations -------------------------------------------------
  belongs_to :almighty, inverse_of: :accounts
  has_many :pokes, inverse_of: :account, dependent: :destroy

  # --------- Validations --------------------------------------------------
  validates :name, presence: true, uniqueness: {case_sensitive: false, scope: :almighty_id}

  # --------- Callbacks ----------------------------------------------------
  before_validation :strip_name

  private

  def strip_name
    self.name = name.try(:strip)
  end

end
