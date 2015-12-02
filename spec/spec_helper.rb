ENV['RAILS_ENV'] ||= 'test'

# require File.expand_path('../../rails_app/config/environment', __FILE__)
require 'rails/all'
require 'rspec'
require 'rspec/rails'
require 'ip_filter'

# Load support helpers
require 'support/enable_dallistore_cache'
require 'support/enable_redis_cache'

# Configure RSpec
RSpec.configure do |config|
  # config.include Rack::Test::Methods
end

# Configure IP filter gem
IpFilter.configure do |config|
  config.data_folder   = File.expand_path('../fixtures', __FILE__)
  config.geo_ip_dat    = File.expand_path('../fixtures/GeoIP.dat', __FILE__)
  config.ip_code_type  = 'country_code2'
  config.ip_codes      = ['country_code2']
  config.ip_whitelist  = ['127.0.0.1/24']
  config.cache         = nil
  config.allow_loopback = false
  config.ip_exception  = Proc.new {
    raise ArgumentError, ('GeoIP: IP is not in whitelist')
  }
end

# Stub Rack::Request and preload IpFilter::Request
# to get IP location as a request's attribute.
Rack::Request.send :include, IpFilter::Request

def action_call(controller, action, opts)
  env = Rack::MockRequest.env_for('/', 'REMOTE_ADDR' => opts[:ip] || '127.0.0.1')
  status, headers, body = controller.action(action).call(env)
  ActionDispatch::TestResponse.new(status, headers, body)
end
