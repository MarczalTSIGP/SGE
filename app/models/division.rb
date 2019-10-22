class Division < ApplicationRecord
  validates :name, :description, presence: true

  belongs_to :department
  has_many :division_users, dependent: :destroy
  has_many :divisions, through: :division_users
  has_many :users, through: :division_users
  has_many :roles, through: :division_users

  def self.search(search)
    if search
      where('unaccent(name) ILIKE unaccent(?)',
            "%#{search}%").order('name ASC')
    else
      order('name ASC')
    end
  end

  def self.not_in_user(department, div)
    User.where(id: department.users).where.not(id: div.users)
  end

  def self.responsible(user)
    joins(:division_users).where(division_users: { role_id: Role.find_by(identifier: 'responsible'),
                                                   user_id: user })
  end

  def self.permission(user, dept_id, div_id)
    dept = Department.manager(user.id)
    div = Division.responsible(user.id)
    permission = true
    unless dept_id.nil? && div_id.nil?
      if dept.ids.include?(dept_id.to_i)
      elsif !div.ids.include?(div_id.to_i)
        permission = false
      end
    end
    permission
  end
end
