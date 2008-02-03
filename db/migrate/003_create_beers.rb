class CreateBeers < ActiveRecord::Migration
  def self.up
    create_table :beers do |t|
      t.column :title, :string
      t.column :abv, :float
      t.column :original_gravity, :float
      t.column :final_gravity, :float
      t.column :style_id, :integer
      t.column :created_at, :timestamp
    end
    add_index :beers, :title
    add_index :beers, :style_id
  end

  def self.down
    drop_table :beers
  end
end
