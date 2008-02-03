##
# This model will represent a beverage produced by a Brewery.
#
class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_one_tuxwiki_page :owner_class => 'Beer'
  belongs_to :style
  validates_presence_of :style_id
  has_many_tagged_images
  has_many :experiences, :dependent => :destroy
  has_many :people, :through => :experiences
  
  ##
  # Returns a list of attributes for the Page partial.
  #
  def page_attributes
    pattr = []
    unless brewery.nil?
      pattr << "Brewery: #{brewery.title}"
    end
    pattr << "ABV: #{"%.1f" % abv}%" unless abv.to_s.empty?
    unless original_gravity.to_s.empty?
      pattr << "Original Gravity: #{original_gravity}"
    end
    unless final_gravity.to_s.empty?
      pattr << "Final Gravity: #{final_gravity}"
    end
    pattr << "Style: #{style.title}"
    pattr
  end
end
