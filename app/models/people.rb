##
# This model represents a user in the system.
#
class People < ActiveRecord::Base
  has_one_tuxwiki_page :owner_class => 'People'
  belongs_to :role
  attr_protected :role_id
  has_many :created_pages, :class_name => 'Page', :foreign_key => 'created_by'
  has_many :updated_pages, :class_name => 'Page', :foreign_key => 'updated_by'
  has_many :images, :dependent => :destroy
  has_many_tagged_images
  validates_uniqueness_of :title
  
  make_authenticatable
  validates_length_of :password, :minimum => 8, :if => :password_required?,
    :message => 'must be at least 8 characters in length'
  
  ##
  # Finds me.
  #
  def self.penguincoder
    @penguincoder ||= self.find_by_title('PenguinCoder') rescue nil
    @penguincoder
  end
  
  protected
  
  ##
  # Determines if the password is needed.
  #
  def password_required?
    self.encrypted_password.blank?
  end
end
