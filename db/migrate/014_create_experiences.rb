class CreateExperiences < ActiveRecord::Migration
  def self.up
    create_table :experiences do |t|
      t.column :people_id, :integer
      t.column :beer_id, :integer
      t.column :rating, :integer
      t.column :created_at, :timestamp
    end
    add_index :experiences, :people_id
    add_index :experiences, :beer_id
  end

  def self.down
    drop_table :experiences
  end
end
