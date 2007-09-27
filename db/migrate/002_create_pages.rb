class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :title, :string
      t.column :redcloth, :text
      t.column :html, :text
      t.column :owner_id, :integer
      t.column :owner_type, :string, :limit => 32
      t.column :version, :integer
    end
    add_index :pages, :owner_id
    Page.create_versioned_table
  end

  def self.down
    drop_table :pages
    Page.drop_versioned_table
  end
end
