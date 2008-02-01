class TagImage < ActiveRecord::Base
  belongs_to :image
  belongs_to :tagged, :polymorphic => true
  validates_presence_of :image_id, :tagged_id, :tagged_type
  validates_uniqueness_of :tagged_id, :scope => :tagged_type
  
  def self.types_for_select
    [ 'Beer', 'People', 'Brewery' ].collect { |x| [x] }
  end
end
