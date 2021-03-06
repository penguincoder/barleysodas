module ApplicationHelper
  ##
  # Returns the title for a page. This could be a Page title or something else.
  #
  def page_title
    "BarleySodas :: #{content_title} :: #{secondary_title}"
  end
  
  ##
  # Returns a pretty name for the current chunk.
  #
  def content_title
    return h(@content_title) if @content_title
    controller.controller_name.camelcase
  end
  
  ##
  # Returns a secondary title for a page. Returns @secondary_title or the
  # action in the controller.
  #
  def secondary_title
    return h(@secondary_title) if @secondary_title
    ''
  end
  
  ##
  # Returns a link for a Page model.
  #
  def link_to_page(page)
    link_to h(page.title), page_path(page)
  end
  
  ##
  # Helper to set the allow_discussions field in the Page model.
  #
  def allow_page_discussions
    @page.allow_discussions = true
  end

  ##
  # Helper to check if Discussion is allowed. This should check the underlying
  # permissions first instead of looking in the model.
  #
  def discussions_allowed?
    @page and @page.allow_discussions?
  end
  
  ##
  # Generates a Tag cloud.
  #
  def tag_cloud(tags, classes = tag_cloud_styles)
    max, min = 0, 0
    tags.each do |t|
      max = t.count.to_i if t.count.to_i > max
      min = t.count.to_i if t.count.to_i < min
    end
    divisor = ((max - min) / classes.size) + 1
    tags.each do |t|
      yield t.name, classes[(t.count.to_i - min) / divisor]
    end
  end
  
  ##
  # Returns an array of Tag styles for a cloud.
  #
  def tag_cloud_styles
    %w(tag_cloud_1 tag_cloud_2 tag_cloud_3 tag_cloud_4 tag_cloud_5)
  end
  
  ##
  # Replaces a WikiWord link with a link to a Page, if it exists.
  #
  def replace_wiki_words(str)
    str.gsub(/\[\[([A-Za-z0-9 \\]+)\]\]/) do |match|
      c_string, page_string = params[:controller], $1
      if $1.match(/\\/)
        ary = $1.split(/\\/)
        c_string, page_string = ary.first, ary.last
      end
      owner_type = c_string.singularize.humanize
      res = ''
      if Page.exists?(page_string, owner_type)
        res = link_to(page_string, { :controller => c_string, :action => :show,
          :id => page_string.gsub(/ /, '_') },
          { :title => "View #{page_string}" })
      else
        res = link_to(page_string, { :controller => c_string,
          :action => :new, :new_title => page_string },
          { :title => "Create #{page_string}" }) + '?'
      end
      res
    end
  end
  
  ##
  # Captures a block output and renders it in a partial as <tt>body</tt>
  #
  def block_to_partial(partial_name, options = {}, &block)
    options.merge!(:body => capture(&block))
    concat(render(:partial => partial_name, :locals => options), block.binding)
  end
  
  ##
  # Helper to build a prototype dialog.
  #
  def lightbox(options = {}, &block)
    options = {
      :title => 'DialogTitle',
      :window_id => 'DialogId',
      :modal => false
    }.merge(options)
    block_to_partial('shared/lightbox', options, &block)
  end
  
  ##
  # Renders everything you need to display the TagImage browser.
  #
  def tagged_image_browser(obj)
    render(:partial => 'shared/tagged_image_browser',
      :locals => { :obj => obj })
  end
  
  ##
  # Pagination link image browser thingey for the tagged image lightbox.
  #
  def image_browser_navigation_link(image_name, page_number, total_pages,
                                    tagged_class, tagged_id)
    if page_number == 0 or
       (page_number == 1 and total_pages == 1) or
       (page_number > total_pages)
      image_tag(image_name)
    else
      link_to_remote image_tag(image_name), :update => 'browser_box',
        :url => { :controller => 'tag_images', :action => 'tagged_images',
        :id => tagged_id, :tagged_type => tagged_class, :page => page_number }
    end
  end
  
  ##
  # Link to open the dialog box for the tagged image browser.
  #
  def tagged_image_browser_link(obj = nil)
    link_to_function('Tagged Images',
      "lightboxes['tagged_image_browser'].open()") +
      (obj ? " (#{obj.tagged_images.size})" : '')
  end
end
