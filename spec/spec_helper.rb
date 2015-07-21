ENV["RAILS_ENV"] ||= 'test'

# require File.expand_path('../../rails_app/config/environment', __FILE__)
require "rails/all"
require 'rspec'
require 'rspec/rails'
require 'ip_filter'

# Configure RSpec
RSpec.configure do |config|
  # config.include Rack::Test::Methods
end

#Configure IP filter gem

# Location of GeoIP database file.
IpFilter::Configuration.data_folder = File.expand_path('../GeoIP/', __FILE__)

# Type of ip country code to compare by.
IpFilter::Configuration.ip_code_type = "country_code2"

# Must be of the corresponding format as :ip_code_type
IpFilter::Configuration.ip_codes = Proc.new { ["country_code2"]}

# Whitelist of IPs
IpFilter::Configuration.ip_whitelist = Proc.new { ["127.0.0.1/24"] }

# Exception to throw when IP is NOT allowed.
# Accepts a Proc for fine-grain control of the appropriate response.
IpFilter::Configuration.ip_exception = Proc.new { raise Exception.new('GeoIP: IP is not in whitelist') }

# Cache object (Memcache only).
IpFilter::Configuration.cache = nil

#--------------------------------------------------------------------------------------------

def action_call(controller, action, opts)

  env = Rack::MockRequest.env_for('/', 'REMOTE_ADDR' => opts[:ip] || '127.0.0.1')
  status, headers, body = controller.action(action).call(env)
  response = ActionDispatch::TestResponse.new(status, headers, body)
end
