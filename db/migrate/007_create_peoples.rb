class CreatePeoples < ActiveRecord::Migration
  def self.up
    create_table :peoples do |t|
      t.column :title, :string
    end
  end

  def self.down
    drop_table :peoples
  end
end
