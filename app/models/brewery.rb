##
# This model represents a company that produces Beer.
#
class Brewery < ActiveRecord::Base
  has_many :beers
  has_one_tuxwiki_page :owner_class => 'Brewery'
  has_many_tagged_images
  
  ##
  # Returns a list of attributes to add into the Page display.
  #
  def page_attributes
    pattr = []
    pattr << "Available Beers: #{beers.size}"
    pattr
  end
end
