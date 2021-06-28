class AddReturnOrderToOrders < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :return_items, :string
  	add_column :orders, :return, :boolean
  	add_column :orders, :return_date, :string
  	add_column :orders, :return_price, :decimal, :precision => 10, :scale => 2
  end
end
