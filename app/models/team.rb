class Team < ApplicationRecord

  # --------- Associations -------------------------------------------------
  has_many :pokes, inverse_of: :team, dependent: :destroy

  has_many :memberships, inverse_of: :team, dependent: :destroy
  has_many :team_members, -> {distinct}, through: :memberships, source: :user

  has_many :leading_memberships, -> {where(kind: Membership::MT_TEAM_LEADER)}, class_name: 'Membership', dependent: :destroy
  has_many :team_leaders, through: :leading_memberships, source: :user do

    def destroy(user)
      if user.is_a?(User) and self.where.not(id: user.id).exists?
        super
      else
        p "Can not destroy the lone team leader in team"
        false
      end
    end

    def delete(user)
      if user.is_a?(User) and self.where.not(id: user.id).exists?
        super
      else
        p "Can not delete the lone team leader in team"
        false
      end
    end

  end

  # --------- Validations --------------------------------------------------
  validates :name, presence: true, uniqueness: {case_sensitive: false}

end
