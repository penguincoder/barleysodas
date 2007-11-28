class ApplicationController < ActionController::Base
  session :session_key => '_barleysodas_session_id'
  append_before_filter :block_prefetching_links
  
  ##
  # Ensures that the request was made using an Ajax request.
  #
  def ensure_xhr
    return false unless request.xhr?
    true
  end
  
  ##
  # Sane error and missing document messages.
  #
  def rescue_action_in_public(exception)
    logger.debug("#{exception.class.name}: #{exception.to_s}")
    exception.backtrace.each { |bt| logger.debug "! #{bt}" }
    case exception
      when ::ActiveRecord::RecordNotFound,
           ::ActionController::UnknownController,
           ::ActionController::UnknownAction,
           ::ActionController::RoutingError
        render :file => File.join(RAILS_ROOT, 'public/404.html'),
          :status => '404 Not Found'
      else
        render :file => File.join(RAILS_ROOT, 'public/500.html'),
          :status => '500 Error'
    end
  end
  
  ##
  # Sets the <tt>@page</tt> variable to allow discussions. This should probably
  # have some kind of permission availability check later on.
  #
  def allow_page_discussions
    @page.allow_discussions = true
  end
  
  private
  
  ##
  # Stops all prefetching by the Google web accelerator by returning a 403
  # forbidden error.
  #
  # Original Copyright:
  # Copyright (c) 2005 David Heinemeier Hansson
  #
  # Permission is hereby granted, free of charge, to any person obtaining
  # a copy of this software and associated documentation files (the
  # "Software"), to deal in the Software without restriction, including
  # without limitation the rights to use, copy, modify, merge, publish,
  # distribute, sublicense, and/or sell copies of the Software, and to
  # permit persons to whom the Software is furnished to do so, subject to
  # the following conditions:
  #
  # The above copyright notice and this permission notice shall be
  # included in all copies or substantial portions of the Software.
  #
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  # EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  # MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  # NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  # LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  # OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  # WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  #
  def block_prefetching_links
    if request.env["HTTP_X_MOZ"] == "prefetch"
      render :nothing => true, :status => "403 Forbidden"
      return false
    end
  end
end
