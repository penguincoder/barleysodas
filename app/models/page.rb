##
# This is a representation of a page of the wiki. My wiki is awfully simple
# because i don't like too many features. This works and it has many different
# associations. All of the major models has_one of these and it belongs_to
# some kind of polymorphic owner.
#
# Bonuses:
# * Uses RedCloth markup.
# * Automatically converts/caches HTML
# * Allows any alphanumeric character or space in the name
# * Uses [[ and ]] for WikiWord representation.
#
class Page < ActiveRecord::Base
  acts_as_versioned
  acts_as_taggable
  
  belongs_to :owner, :polymorphic => true
  has_many :discussions, :order => 'discussions.created_at ASC',
    :dependent => :destroy
  
  belongs_to :created_by, :class_name => 'People', :foreign_key => 'created_by'
  belongs_to :updated_by, :class_name => 'People', :foreign_key => 'updated_by'
  
  validates_presence_of :title
  validates_uniqueness_of :title, :scope => 'owner_type'
  validates_format_of :title, :with => /^([A-Za-z0-9 ])+$/,
    :message => 'may only contain letters, numbers and spaces'
  before_save :update_html
  
  before_create :set_created_person
  before_save :set_updated_person
  
  attr_protected :allow_discussions, :created_by, :updated_by
  
  ##
  # Returns an url-friendly title for making links.
  #
  def title_for_url
    self.title.gsub(/ /, '_')
  end
  
  ##
  # Gets a title from an url name.
  #
  def self.title_from_url(title)
    title.to_s.gsub(/_/, ' ')
  end
  
  ##
  # Returns a list of Tag models for a type of Page.
  #
  # Can take options of :order, :limit, and :owner_type
  #
  def self.tags(options = {})
    query = "select tags.id, name, count(*) as count"
    query << " from tags_pages, tags, pages"
    query << " where tags.id = tag_id"
    if options[:owner_type].nil?
      query << " and pages.owner_type IS NULL"
    else
      query << " and pages.owner_type = '#{options[:owner_type]}'"
    end
    query << " and tags_pages.page_id = pages.id"
    query << " group by tags.id, tags.name"
    query << " order by #{options[:order]}" if options[:order] != nil
    query << " limit #{options[:limit]}" if options[:limit] != nil
    tags = Tag.find_by_sql(query)
  end
  
  protected
  
  ##
  # Sets the People marker for created_by on creation.
  #
  def set_created_person
    self[:created_by] = ApplicationController.current_people_id rescue nil
    self[:created_by] ||= People.penguincoder.id
  end
  
  ##
  # Sets the People marker for updated_by on save.
  #
  def set_updated_person
    self[:updated_by] = ApplicationController.current_people_id rescue nil
    self[:updated_by] ||= People.penguincoder.id
  end
  
  ##
  # Updates the HTML chunk from the RedCloth source.
  #
  def update_html
    # need to filter HTML first... remove <script> and chunks and the like...
    res = RedCloth.new(strip_tags(self.redcloth.to_s), [ :no_span_caps ])
    self.html = res.to_html(
      # no link references. messes up lines starting with [[WikiWord]]
      :block_textile_table, :block_textile_lists, :block_textile_prefix,
      :inline_textile_image, :inline_textile_link, :inline_textile_code,
      :inline_textile_span, :glyphs_textile)
  end
  
  ##
  # Removes HTML tags from a string
  #
  def strip_tags(str)
    str.gsub(/\</, "&lt;").gsub(/\>/, "&gt;")
  end
end
