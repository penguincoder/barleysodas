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
  has_many :friends, :foreign_key => :source_id, :dependent => :destroy
  has_many :actual_friends, :through => :friends, :source => :destination
  has_many :experiences, :dependent => :destroy
  has_many :beers, :through => :experiences
  has_many :invitations, :dependent => :destroy,
    :conditions => [ 'sent IS NULL or sent = ?', false ]
  
  make_authenticatable
  validates_length_of :password, :minimum => 8, :if => :password_required?,
    :message => 'must be at least 8 characters in length'
  
  before_create :set_user_role
  
  ##
  # Used to quickly determine if the particular id of another Person is a
  # Friend of this instance.
  #
  def friend_of?(people_id)
    Friend.count(:conditions => [ 'source_id = ? AND destination_id = ?',
      people_id, id ]) > 0
  end
  
  ##
  # Finds me.
  #
  def self.penguincoder
    @penguincoder ||= self.find_by_title('PenguinCoder') rescue nil
    @penguincoder
  end
  
  protected
  
  ##
  # Forces the People Role to be a tame default unless otherwise overridden.
  #
  def set_user_role
    self.role = Role.normal_role if self.role.nil?
  end
  
  ##
  # Determines if the password is needed.
  #
  def password_required?
    self.encrypted_password.blank?
  end
end
