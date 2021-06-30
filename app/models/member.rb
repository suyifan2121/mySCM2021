class Member < ApplicationRecord
  belongs_to :user
  has_many :orders
  has_many :items, through: :orders

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true

  def get_role
  	case self.role
      when "superadmin"
        return "Super Admin"
      when "sysadmin"
        return "System Admin"
      when "inventoryadmin"
        return "Inventory Admin"
      when "purchasingagent"
        return "Purchasing Agent"
      when "salesagent"
        return "Sales Agent"
      end
  end

end
