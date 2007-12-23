##
# This model represents a user in the system.
#
class People < ActiveRecord::Base
  has_one_tuxwiki_page :owner_class => 'People'
  belongs_to :role
  attr_protected :role_id
  
  ##
  # Finds the Guest user for the system.
  #
  def self.guest_user
    self.find_by_title('Guest') rescue nil
  end
end
