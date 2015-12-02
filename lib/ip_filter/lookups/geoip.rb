require 'ip_filter/lookups/base'
require 'ip_filter/results/geoip'
require 'geoip'

module IpFilter
  module Lookup
    class Geoip < Base
      private

      def fetch_data(query)
        data = cache[query]
        unless cache && data
          data = geo_ip_lookup.country(query).to_hash
          cache[query] = data if cache
        end
        data
      end

      def geo_ip_lookup
        @geo_ip_lookup ||= GeoIP.new(IpFilter.reference_file)
      end

      def results(query)
        # don't look up a loopback address, just return the stored result
        return [reserved_result(query)] if loopback_address?(query)
        [fetch_data(query)]
      end

      def reserved_result(ip)
        {
          ip:             ip,
          country_code:   'N/A',
          country_code2:  'N/A',
          country_code3:  'N/A',
          country_name:   'N/A',
          continent_code: 'N/A'
        }
      end
    end
  end
end
