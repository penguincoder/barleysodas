##
# This model represents a user in the system.
#
class People < ActiveRecord::Base
  has_one_tuxwiki_page :owner_class => 'People'
  belongs_to :role
  attr_protected :role_id
  validates_presence_of :role_id
  
  before_create :set_base_role
  
  protected
  
  ##
  # Sets the Role to the top level model.
  #
  def set_base_role
    self.role = Role.base_role
  end
end
