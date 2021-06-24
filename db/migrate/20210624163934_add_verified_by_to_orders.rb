class AddVerifiedByToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :verified_by, :string
  end
end
