class AddRetailPriceToItems < ActiveRecord::Migration[5.0]
  def change
  	add_column :items, :retail_price, :decimal, :precision => 10, :scale => 2
  end
end
