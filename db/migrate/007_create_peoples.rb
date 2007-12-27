class CreatePeoples < ActiveRecord::Migration
  def self.up
    create_table :peoples do |t|
      t.column :title, :string
    end
    People.create :title => 'Guest', :page => Page.new
    People.create :title => 'PenguinCoder', :page => Page.new
  end

  def self.down
    drop_table :peoples
  end
end
