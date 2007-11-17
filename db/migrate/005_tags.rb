class Tags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :name, :string
    end
    create_table :tags_pages, :id => false do |t|
      t.column :tag_id, :integer
      t.column :page_id, :integer
    end
    add_index :tags, :name
    add_index :tags_pages, [ :tag_id, :page_id ]
  end

  def self.down
    drop_table :tags
    drop_table :tags_pages
  end
end
