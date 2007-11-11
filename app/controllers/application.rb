class ApplicationController < ActionController::Base
  session :session_key => '_barleysodas_session_id'
  
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
