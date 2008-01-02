class CreatePeoples < ActiveRecord::Migration
  def self.up
    create_table :peoples do |t|
      t.column :title, :string
      t.column :role_id, :integer
    end
    add_index :peoples, :title
    add_index :peoples, :role_id
    p = People.new :title => 'PenguinCoder', :page => Page.new
    p.role = Role.admin_role
    p.save
  end

  def self.down
    drop_table :peoples
  end
end
