class Item < ApplicationRecord
  has_many :members, through: :orders

  validates :name, presence: true
  validates :category, presence: true

  # custom function to get purchase_price to display purchase_price in MYR eg. 32.5 -> 32.50
  def get_purchase_price
    "RM #{sprintf "%.2f", self.purchase_price}" unless purchase_price.nil?
  end

  def get_retail_price
    "RM #{sprintf "%.2f", self.retail_price}" unless retail_price.nil?
  end
end
