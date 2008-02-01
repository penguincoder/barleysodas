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
      def has_many_tagged_images(options = {})
        class_eval do
          has_many :tagged_images, :source_type => self.base_class.to_s,
            :source => :tagged, :through => :tag_images
          has_many :tag_images, :dependent => :destroy, :as => :tagged
        end
      end
    end
  end
end
