class AutocompleteController < ApplicationController
  append_before_filter :ensure_xhr
  
  ##
  # Automatically finds and returns a nice list of things. It is stupid in that
  # it only finds the first thing available, but it will find it all.
  #
  # It expects to have parameters passed in the form:
  #
  #   'brewery' => { 'name' => 'foo' }
  #
  # Only one of those sets. If this is done, then all will be peachy.
  #
  def index
    key = params.keys.detect do |x|
      x.to_s != 'action' and x.to_s != 'controller'
    end
    render :nothing => true, :status => 500 if key.nil?
    @value = params[key].keys.first
    class_name = key.camelize.constantize
    render :nothing => true unless class_name.new.respond_to?(@value)
    @items = class_name.find(:all, :order => "#{@value} ASC", :select => @value,
      :conditions => [ "lower(#{@value}) LIKE ?",
        "%#{params[key][@value].downcase}%" ])
    render :partial => 'autocomplete/results'
  end
  
  protected
  
  ##
  # Allow pretty much everybody in here. Most likely this will not be able to
  # be misused. At least not right now.
  #
  def authorized?
    true
  end
end
