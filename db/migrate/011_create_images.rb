class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column :people_id, :integer
      t.column :created_at, :datetime
      t.column :original, :string
      t.column :thumbnail, :string
      t.column :screen, :string
      t.column :screen_width, :integer
      t.column :screen_height, :integer
      t.column :content_type, :string
    end
    add_index :images, :people_id
    create_table :images_pages, :id => false do |t|
      t.column :image_id, :integer
      t.column :page_id, :integer
    end
    add_index :images_pages, :image_id
    add_index :images_pages, :page_id
  end

  def self.down
    drop_table :images
    drop_table :images_pages
  end
end
