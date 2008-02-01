class CreateTagImages < ActiveRecord::Migration
  def self.up
    create_table :tag_images do |t|
      t.column :image_id, :integer
      t.column :tagged_id, :integer
      t.column :tagged_type, :string, :limit => 32
      t.column :primary, :boolean
      t.column :x, :integer
      t.column :y, :integer
    end
    add_index :tag_images, :image_id
    add_index :tag_images, :tagged_id
    add_index :tag_images, :tagged_type
  end

  def self.down
    drop_table :tag_images
  end
end
