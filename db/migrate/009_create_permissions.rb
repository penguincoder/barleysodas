class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.column :controller, :string
      t.column :action, :string
      t.column :http_method, :string
    end
    create_table :permissions_roles, :id => false do |t|
      t.column :permission_id, :integer
      t.column :role_id, :integer
    end
    add_index :permissions_roles, :permission_id
    add_index :permissions_roles, :role_id
  end

  def self.down
    drop_table :permissions
    drop_table :permissions_roles
  end
end
