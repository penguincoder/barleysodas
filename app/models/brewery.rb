##
# This model represents a company that produces Beer.
#
class Brewery < ActiveRecord::Base
  has_many :beers
  has_one :page, :foreign_key => 'owner_id', :dependent => :destroy,
    :conditions => "pages.owner_type = 'Brewery'"
  before_save :ensure_page_valid
  after_save :save_page
  
  ##
  # Returns a list of attributes to add into the Page display.
  #
  def page_attributes
    pattr = []
    pattr << "Available Beers: #{beers.size}"
    pattr
  end
  
  protected
  
  ##
  # This model always has a Page associated. Save it before this model to make
  # sure that everything is kosher with the name and whatnot.
  #
  def save_page
    page.save
  end
  
  ##
  # This will let the Page model keep track of names being unique and all.
  # Might be nil, so let the after_save hook create it.
  #
  def ensure_page_valid
    if page.nil?
      self.errors.add(:page, "is missing")
    else
      page.owner = self
      page.title = self.title
      page.errors.each do |key, val|
        self.errors.add(key, val)
      end if !page.valid?
    end
    return false if self.errors.size > 0
    true
  end
end
