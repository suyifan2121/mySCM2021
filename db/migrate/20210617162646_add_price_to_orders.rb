class AddPriceToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :price, :decimal, :precision => 10, :scale => 2
  end
end
