##
# This model represents a user in the system.
#
class People < ActiveRecord::Base
  has_one_tuxwiki_page :owner_class => 'People'
  belongs_to :role
  attr_protected :role_id
  has_many :created_pages, :class_name => 'Page', :foreign_key => 'created_by'
  has_many :updated_pages, :class_name => 'Page', :foreign_key => 'updated_by'
  validates_uniqueness_of :title
  
  ##
  # Finds me.
  #
  def self.penguincoder
    @penguincoder ||= self.find_by_title('PenguinCoder') rescue nil
    @penguincoder
  end
end
