class Order < ApplicationRecord
  belongs_to :member

  validates :quantity, presence: true
  # validates :expire_at, presence: true
  validates :member_id, presence: true

  attr_accessor :item_list, :order_date, :purchase_items, :sales_items

  def self.approve?
    @order = Order.where(id: id)
    @order.update(status: true)
  end

  def self.reject?
    Order.where(status: false)
  end

  def self.pending?
    Order.where(status: false)
  end

  # def self.expired?
  #   Order.where("expire_at < ?", Date.today).where(status: true)
  # end

  # def self.renew id
  #   @order = Order.where(id: id)
  #   @order.update(expire_at: 7.days.from_now)
  # end

  def self.disable id
    @order = Order.where(id: id)
    @order.update(status: false)
  end

  # custom function to get purchase_price to display purchase_price in MYR eg. 32.5 -> 32.50
  def get_purchase_price
    "RM #{sprintf "%.2f", self.purchase_price}" unless purchase_price.nil?
  end

  def get_retail_price
    "RM #{sprintf "%.2f", self.retail_price}" unless retail_price.nil?
  end
end
