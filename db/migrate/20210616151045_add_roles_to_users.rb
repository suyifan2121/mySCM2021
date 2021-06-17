class AddRolesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :superadmin_role, :boolean
    add_column :users, :sysadmin_role, :boolean
    add_column :users, :inventoryadmin_role, :boolean
    add_column :users, :purchasingagent_role, :boolean
    add_column :users, :salesagent_role, :boolean
  end
end
