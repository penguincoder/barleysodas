RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :action_web_service, :action_mailer ]
  config.action_controller.session_store = :active_record_store
  config.active_record.default_timezone = :utc
end

require 'redcloth'