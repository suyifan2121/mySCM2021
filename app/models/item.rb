class Item < ApplicationRecord
  has_many :members, through: :orders

  validates :name, presence: true
  validates :category, presence: true

  # custom function to get price to display price in MYR eg. 32.5 -> 32.50
  def get_price
    "RM #{sprintf "%.2f", self.price}" unless price.nil?
  end
end
