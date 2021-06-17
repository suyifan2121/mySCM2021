class AddPriceToItems < ActiveRecord::Migration[5.0]
  def change
  	# price column with 10 digit limit and 2 decimal points
    add_column :items, :price, :decimal, :precision => 10, :scale => 2
  end
end
