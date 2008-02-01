##
# Represents a relationship of association between two People models.
#
class Friend < ActiveRecord::Base
  belongs_to :source, :class_name => 'People', :foreign_key => :source_id
  belongs_to :destination, :class_name => 'People',
    :foreign_key => :destination_id
  validates_presence_of :source_id, :destination_id
  validates_uniqueness_of :destination_id, :scope => :source_id
  
  validates_each :destination_id do |record, attr, value|
    if value == record.source_id
      record.errors.add(attr, 'cannot be the same as the source')
    end
  end
end
