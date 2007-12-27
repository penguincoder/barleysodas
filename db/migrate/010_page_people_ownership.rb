class PagePeopleOwnership < ActiveRecord::Migration
  def self.up
    add_column :pages, :created_by, :integer
    add_index :pages, :created_by
    add_column :pages, :updated_by, :integer
    add_index :pages, :updated_by
    add_column :page_versions, :created_by, :integer
    add_index :page_versions, :created_by
    add_column :page_versions, :updated_by, :integer
    add_index :page_versions, :updated_by
  end

  def self.down
    remove_column :pages, :created_by
    remove_column :pages, :updated_by
    remove_column :page_versions, :created_by
    remove_column :page_versions, :updated_by
  end
end
