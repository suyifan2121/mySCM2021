class RenamePriceColumnItems < ActiveRecord::Migration[5.0]
  def change
  	rename_column :items, :price, :purchase_price
  end
end
