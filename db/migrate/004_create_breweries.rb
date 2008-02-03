class CreateBreweries < ActiveRecord::Migration
  def self.up
    create_table :breweries do |t|
      t.column :title, :string
      t.column :address_1, :string
      t.column :address_2, :string
      t.column :city, :string
      t.column :state, :string
      t.column :postal_code, :string
      t.column :country, :string
      t.column :created_at, :timestamp
    end
    add_column :beers, :brewery_id, :integer
    add_index :beers, :brewery_id
    add_index :breweries, :title
  end

  def self.down
    drop_table :breweries
    remove_column :beers, :brewery_id
  end
end
