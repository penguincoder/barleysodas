##
# This model will represent a beverage produced by a Brewery.
#
class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_one :page, :foreign_key => 'owner_id', :dependent => :destroy,
    :conditions => "pages.owner_type = 'Beer'"
  before_save :ensure_page_valid
  after_save :save_page
  
  ##
  # Returns a list of attributes for the Page partial.
  #
  def page_attributes
    pattr = []
    pattr << "ABV: #{"%.1f" % abv}%" unless abv.to_s.empty?
    unless original_gravity.to_s.empty?
      pattr << "Original Gravity: #{original_gravity}"
    end
    unless final_gravity.to_s.empty?
      pattr << "Final Gravity: #{final_gravity}"
    end
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
