class AddColumnsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :type, :string
    add_column :orders, :supplier, :string
    add_column :orders, :client, :string
    add_column :orders, :date, :datetime
  end
end
