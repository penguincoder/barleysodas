##
# This model is a grouping of Permission models associated to a particular
# People.
#
class Role < ActiveRecord::Base
  has_many :peoples
  belongs_to :parent, :foreign_key => 'parent_id', :class_name => 'Role'
  validates_presence_of :code, :name
  validates_uniqueness_of :code
  validates_format_of :code, :with => /^([A-Za-z0-9])+$/,
    :message => 'may only contain letters and numbers'
  has_and_belongs_to_many :permissions
  
  ##
  # Ensures that the Role does not have a parent of itself.
  #
  def validate
    if !self.new_record? and self.parent_id == id
      self.errors.add(:parent, 'cannot be self')
    end
    return false if self.errors.size > 0
    true
  end
  
  ##
  # Returns a Role found by +code+ if the method is missing.
  #
  def self.method_missing(method_name, *args)
    return self.find_by_code($1) if method_name.to_s =~ /^(.+)_role$/
    super
  end
  
  ##
  # Returns a select-box compatible array.
  #
  def self.for_select
    self.find(:all).collect { |x| [ x.name, x.id.to_s ] }
  end
end
