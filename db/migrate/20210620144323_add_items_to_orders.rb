class AddItemsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :items, :string
  end
end
