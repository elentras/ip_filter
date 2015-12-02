require 'ip_filter'

module IpFilter
  module Request
    def location
      # For now just grab the first value as the best guess.
      @location ||= IpFilter.search(ip).try(:first)
    end
  end
end

if defined?(Rack) && defined?(Rack::Request)
  Rack::Request.send :include, IpFilter::Request
end
