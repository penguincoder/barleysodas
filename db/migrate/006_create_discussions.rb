class CreateDiscussions < ActiveRecord::Migration
  def self.up
    create_table :discussions do |t|
      t.column :page_id, :integer
      t.column :text, :text
    end
  end

  def self.down
    drop_table :discussions
  end
end
