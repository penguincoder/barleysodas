class Tag < ActiveRecord::Base
  has_and_belongs_to_many :pages, :join_table => 'tags_pages'
end
