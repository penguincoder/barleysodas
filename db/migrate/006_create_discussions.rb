class CreateDiscussions < ActiveRecord::Migration
  def self.up
    create_table :discussions do |t|
      t.column :page_id, :integer
      t.column :text, :text
      t.column :created_at, :timestamp
    end
    add_column :pages, :allow_discussions, :boolean, :default => false
    add_column :page_versions, :allow_discussions, :boolean, :default => false
  end

  def self.down
    drop_table :discussions
    remove_column :pages, :allow_discussions
    remove_column :page_versions, :allow_discussions
  end
end
