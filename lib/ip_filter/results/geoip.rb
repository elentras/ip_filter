require 'ip_filter/results/base'

module IpFilter
  module Result
    class Geoip < Base
      def self.response_attributes
        %w(
          ip country_code country_code2 country_code3 country_name continent_code
        )
      end

      response_attributes.each do |a|
        define_method a do
          @data[a.to_sym]
        end
      end
    end
  end
end
