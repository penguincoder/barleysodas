class Experience < ActiveRecord::Base
  belongs_to :people
  belongs_to :beer
  validates_presence_of :people_id, :beer_id
end
