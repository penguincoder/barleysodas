require 'mini_magick'

class Image < ActiveRecord::Base
  attr_accessor :file
  belongs_to :people
  validates_presence_of :people_id
  before_validation_on_create :set_people_id
  before_create :validate_image_sanity
  after_create :setup_directories
  before_destroy :destroy_directories
  has_many :tag_images, :dependent => :destroy
  has_many :tagged_items, :through => :tag_images
  
  ##
  # Builds the filename for this model for a particular version of the file.
  #
  def filename_for_version(ver = :screen)
    if respond_to?(ver)
      "community/#{id}/#{self.send(ver)}"
    else
      "/images/image-missing.png"
    end
  end
  
  protected
  
  ##
  # Determines the base directory for all files in this model.
  #
  def base_directory
    "#{RAILS_ROOT}/public/images/community/#{id}"
  end
  
  ##
  # Sets the People marker for ownership on creation.
  #
  def set_people_id
    self[:people_id] = ApplicationController.current_people_id rescue nil
    self[:people_id] ||= People.penguincoder.id rescue nil
  end
  
  ##
  # Checks to make sure that the file exists and is an image.
  #
  def validate_image_sanity
    if @file.nil? or @file.to_s.empty?
      errors.add(:file, 'is not a file')
      return false
    end
    errors.add(:file, 'is too big (3MB max)') if @file.size > 3 * 1048576
    begin
      @magick_image = MiniMagick::Image.from_blob(@file.read,
        File.extname(@file.original_filename))
    rescue
      logger.debug("Caught an exception saving an image:")
      logger.debug("* #{$!}")
      errors.add(:file, 'is not an image')
    end
    return false if self.errors.size > 0
    self.content_type = @file.content_type.chomp
    true
  end
  
  ##
  # Makes the directories and writes the different versions for the uploaded
  # files if applicable.
  #
  def setup_directories
    Dir.mkdir(base_directory) unless File.exist?(base_directory)
    self.original = File.basename(@file.original_filename).gsub(/[^\w._-]/, '')
    @magick_image.write("#{base_directory}/#{self.original}")
    @magick_image.thumbnail("600x600>")
    self.screen = "screen_#{self.original}"
    @magick_image.write("#{base_directory}/#{self.screen}")
    if @magick_image.output =~ / (\d+)x(\d+) /
      self.screen_width = $1
      self.screen_height = $2
    end
    @magick_image.thumbnail("50x50>")
    self.thumbnail = "thumbnail_#{self.original}"
    @magick_image.write("#{base_directory}/#{self.thumbnail}")
    self.save
  end
  
  ##
  # Removes the directories and files associated with this model on destroy.
  #
  def destroy_directories
    return unless File.exists?(base_directory)
    Dir.foreach(base_directory) do |file|
      next if file =~ /^\.\.?$/
      File.delete(base_directory + '/' + file)
    end
    Dir.delete(base_directory)
  end
end
