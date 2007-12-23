class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :name, :string
      t.column :code, :string
      t.column :parent_id, :integer
    end
    add_index :roles, :parent_id
    add_index :roles, :code
    add_column :peoples, :role_id, :integer
    add_index :peoples, :role_id
    br = Role.create :code => 'base', :name => 'Base Role'
    ar = Role.create :code => 'admin', :name => 'Administrative Role',
      :parent_id => br.id
    g = People.guest_user
    g.role = br
    g.save
  end

  def self.down
    drop_table :roles
    remove_column :peoples, :role_id
  end
end
