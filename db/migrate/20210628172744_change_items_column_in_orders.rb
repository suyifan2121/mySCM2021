class ChangeItemsColumnInOrders < ActiveRecord::Migration[5.0]
  def change
  	change_column :orders, :items, :text
  end
end
