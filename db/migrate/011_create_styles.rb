class CreateStyles < ActiveRecord::Migration
  def self.up
    create_table :styles do |t|
      t.column :title, :string
      t.column :parent_id, :integer
      t.column :position, :integer
      t.column :page_id, :integer
      t.column :gravity_bottom, :decimal, :precision => 4
      t.column :gravity_top, :decimal, :precision => 4
      t.column :originating_location, :string
    end
    add_index :styles, :title
    add_index :styles, :parent_id
  end

  def self.down
    drop_table :styles
  end
end
