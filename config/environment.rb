require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :action_web_service ]
  config.action_controller.session_store = :active_record_store
  config.active_record.default_timezone = :utc
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
end

require 'redcloth'
require 'has_one_page'
require 'has_many_tagged_images'
