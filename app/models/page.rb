##
# This is a representation of a page of the wiki. My wiki is awfully simple
# because i don't like too many features. This works and it has many different
# associations. All of the major models has_one of these and it belongs_to
# some kind of polymorphic owner.
#
# Bonuses:
# * Uses RedCloth markup.
# * Automatically converts/caches HTML
# * Allows any character or space in the name
# * Uses [[ and ]] for WikiWord representation.
#
class Page < ActiveRecord::Base
  acts_as_versioned
  acts_as_taggable
  
  belongs_to :owner, :polymorphic => true
  validates_presence_of :title
  validates_uniqueness_of :title, :scope => 'owner_type'
  validates_format_of :title, :with => /^([A-Za-z0-9 ])+$/,
    :message => 'may only contain letters, numbers and spaces'
  before_save :update_html
  
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
  
  protected
  
  ##
  # Updates the HTML chunk from the RedCloth source.
  #
  def update_html
    # need to filter HTML first... remove <script> and chunks and the like...
    res = RedCloth.new(self.redcloth.to_s.strip_tags, [ :no_span_caps ])
    self.html = res.to_html(
      # no link references. messes up lines starting with [[WikiWord]]
      :block_textile_table, :block_textile_lists, :block_textile_prefix,
      :inline_textile_image, :inline_textile_link, :inline_textile_code,
      :inline_textile_span, :glyphs_textile)
  end
end
