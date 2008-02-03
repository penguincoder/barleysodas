class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :name, :string
      t.column :code, :string
      t.column :parent_id, :integer
    end
    add_index :roles, :parent_id
    add_index :roles, :code
    br = Role.create :code => 'base', :name => 'Base Role'
    ar = Role.create :code => 'admin', :name => 'Administrative Role',
      :parent_id => br.id
    nr = Role.create :code => 'normal', :name => 'Normal User Role',
      :parent_id => br.id
  end

  def self.down
    drop_table :roles
  end
end
