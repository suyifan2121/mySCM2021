class Client < ApplicationRecord
  has_many :orders

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true

end
