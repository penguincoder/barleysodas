class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :title, :string
      t.column :redcloth, :text
      t.column :html, :text
      t.column :owner_id, :integer
      t.column :owner_type, :string, :limit => 32
      t.column :version, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :created_by, :integer
      t.column :updated_by, :integer
    end
    add_index :pages, :title
    add_index :pages, :owner_id
    add_index :pages, :owner_type
    add_index :pages, :created_by
    add_index :pages, :updated_by
    Page.create_versioned_table
  end

  def self.down
    drop_table :pages
    Page.drop_versioned_table
  end
end
