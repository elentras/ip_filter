require 'ipaddr'

module IpFilter
  module Lookup
    class Base
      # A number of non-routable IP ranges.
      #
      # --
      # Sources for these:
      #   RFC 3330: Special-Use IPv4 Addresses
      #   The bogon list: http://www.cymru.com/Documents/bogon-list.html
      NON_ROUTABLE_IP_RANGES = [
        IPAddr.new('0.0.0.0/8'),      # 'This' Network
        IPAddr.new('10.0.0.0/8'),     # Private-Use Networks
        IPAddr.new('14.0.0.0/8'),     # Public-Data Networks
        IPAddr.new('127.0.0.0/8'),    # Loopback
        IPAddr.new('169.254.0.0/16'), # Link local
        IPAddr.new('172.16.0.0/12'),  # Private-Use Networks
        IPAddr.new('192.0.2.0/24'),   # Test-Net
        IPAddr.new('192.168.0.0/16'), # Private-Use Networks
        IPAddr.new('198.18.0.0/15'),  # Network Interconnect Device Benchmark Testing
        IPAddr.new('224.0.0.0/4'),    # Multicast
        IPAddr.new('240.0.0.0/4')     # Reserved for future use
      ].freeze

      # Query the GeoIP database for a given IP address, and returns information
      # about the region/country where the IP address is allocated.
      #
      # Takes a search string (eg: '205.128.54.202') for country info
      # Returns an array of <tt>IpFilter::Result</tt>s.
      def search(query)
        results(query).map { |r| result_class.new(r) }
      end

      private

      # IpFilter::Result object or nil on timeout or other error.
      def results(query, reverse = false)
        raise NotImplementedError.new
      end

      # Class of the result objects.
      def result_class
        IpFilter::Result.const_get(self.class.to_s.split(':').last)
      end

      # The working Cache object.
      def cache
        IpFilter.cache
      end

      # Checks if address is a loopback/private address range.
      def loopback_address?(ip)
        NON_ROUTABLE_IP_RANGES.any? { |range| range.include?(ip) }
      end
    end
  end
end
