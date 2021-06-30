class Supplier < ApplicationRecord
  has_many :orders

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true
  validates :phone, presence: true

end
