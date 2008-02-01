class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.column :source_id, :integer
      t.column :destination_id, :integer
      t.column :rank, :integer
      t.column :created_at, :timestamp
    end
    add_index :friends, :source_id
    add_index :friends, :destination_id
  end

  def self.down
    drop_table :friends
  end
end
