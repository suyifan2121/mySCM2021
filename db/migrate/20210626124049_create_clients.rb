class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
    	t.string :name
	    t.string :contact_person
	    t.string :phone
	    t.string :email
	    t.string :address

	    t.timestamps
    end
  end
end
