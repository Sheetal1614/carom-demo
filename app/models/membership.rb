class Membership < ApplicationRecord

  # --------- Constants ----------------------------------------------------
  MT_TEAM_LEADER = 'team_leader'
  POSSIBLE_KINDS = [MT_TEAM_LEADER]

  # --------- Associations -------------------------------------------------
  belongs_to :team, inverse_of: :memberships
  belongs_to :user, inverse_of: :memberships

  # --------- Validations --------------------------------------------------
  validates :kind, inclusion: {in: POSSIBLE_KINDS, allow_nil: true}

end