module ActiveRecord # :nodoc:
  class Base # :nodoc:
    class << self
      ##
      # This method will add a has_one :page association and a few useful
      # callbacks to the requested model. It expects to have a
      # :owner_class parameter given so that it knows what the owner class
      # name should be. The associated model will automatically be deleted
      # when this model is deleted.
      #
      # The Page will automatically have the title updated from the owner's
      # title field and be saved after a successful save. When a Page errors
      # on validation, the errors are automatically copied into the owner so
      # that the user doesn't even have to know what is going on.
      #
      def has_one_tuxwiki_page(options = {})
        return if self.included_modules.include?(TuxWiki::HasOnePage)
        send :include, TuxWiki::HasOnePage
        
        # we need a class name for right now. i don't know how to inflect it
        # on my own, yet.
        options[:owner_class] ||= 'Page'
        
        class_eval do
          has_one :page, :foreign_key => 'owner_id', :dependent => :destroy,
            :conditions => "pages.owner_type = '#{options[:owner_class]}'",
            :include => 'tags'
          before_save :ensure_tuxwiki_page_valid
          after_save :save_tuxwiki_page
        end
      end
    end
  end
end

module TuxWiki # :nodoc:
  module HasOnePage # :nodoc:
    
    protected
    
    ##
    # This model always has a Page associated. Save it before this
    # model to make sure that everything is kosher with the name and
    # whatnot.
    #
    def save_tuxwiki_page
      self.page.save
    end
    
    ##
    # This will let the Page model keep track of names being unique and
    # all. Might be nil, so let the after_save hook create it. Also
    # copies the errors from the page model into the owner model.
    #
    def ensure_tuxwiki_page_valid
      if self.page.nil?
        self.errors.add(:page, "is missing")
      else
        self.page.owner = self
        self.page.title = self.title
        self.page.errors.each do |key, val|
          self.errors.add(key, val)
        end if !self.page.valid?
      end
      return false if self.errors.size > 0
      true
    end
  end
end
