##
# Models the ability to perform an action in the system.
#
class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles
  validates_presence_of :controller, :action
  
  def to_s # :nodoc:
    "#{controller} :: #{action}"
  end
  
  ##
  # Helper to find the necessary models for a form edit.
  #
  def self.find_for_form
    self.find(:all, :order => "controller ASC, action ASC")
  end
end
