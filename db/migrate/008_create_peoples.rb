class CreatePeoples < ActiveRecord::Migration
  def self.up
    create_table :peoples do |t|
      t.column :title, :string
      t.column :role_id, :integer
      t.column :encrypted_password, :string, :limit => 512
      t.column :salt, :string, :limit => 512
    end
    add_index :peoples, :title
    add_index :peoples, :role_id
    p = People.new :title => 'PenguinCoder', :page => Page.new,
      :password => 'new_password', :password_confirmation => 'new_password'
    p.role = Role.admin_role
    p.save
  end

  def self.down
    drop_table :peoples
  end
end
