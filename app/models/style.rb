##
# Represents a category that a Beer belongs to.
#
class Style < ActiveRecord::Base
  has_one_tuxwiki_page :owner_class => 'Style'
  belongs_to :parent, :foreign_key => 'parent_id',
    :class_name => 'Style'
  has_many :children, :foreign_key => 'parent_id',
    :class_name => 'Style', :order => 'position ASC'
  validates_presence_of :position
  has_many :beers
  
  ##
  # Top level beer styles.
  #
  def self.major_styles
    self.find(:all, :conditions => [ 'parent_id IS NULL' ],
      :order => 'position ASC')
  end
  
  ##
  # Returns a select compatible array for views.
  #
  def self.for_select
    self.find(:all, :include => [ 'parent' ]).sort { |a,b|
      if !a.parent.nil? and !b.parent.nil? and
         a.parent.position == b.parent.position
        a.position <=> b.position
      elsif a.parent.nil? and !b.parent.nil? and a.position == b.parent.position
        -1
      elsif !a.parent.nil? and b.parent.nil? and a.parent.position == b.position
        1
      else
        (a.parent.nil? ? a.position : a.parent.position) <=>
          (b.parent.nil? ? b.position : b.parent.position)
      end
    }.collect { |s|
      unless s.parent.nil?
        [ "* #{s.position}. #{s.title}", s.id.to_s ]
      else
        [ "#{s.position}. #{s.title}", s.id.to_s ]
      end
    }
  end
  
  ##
  # Returns a list of attributes for a Page render.
  #
  def page_attributes
    pattr = []
    unless parent.nil?
      pattr << "Parent Style: #{parent.title}"
      pattr << "Category Number: #{parent.position}.#{position}"
    else
      pattr << "Category Number: #{position}"
    end
    pattr << "Beers in this style: #{beers.size}"
    pattr
  end
end
