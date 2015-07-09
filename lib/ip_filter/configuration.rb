module IpFilter
  class Configuration

    def self.options_and_defaults
      [
        # Location of GeoLite database dat file.
        [:geo_ip_dat, "/lib/assets/GeoIP.dat"],

        # Logic to use to update geoip.dat file
        [:update_method, Proc.new { }],

        # Must be "country_code", "country_code2", "country_code3",
        # "country_name", "continent_code"
        [:ip_code_type, nil],

        # Must be of the corresponding format as :ip_code_type
        [:ip_codes, Proc.new { }],

        # Whitelist of IPs
        [:ip_whitelist, Proc.new { }],

        # Exceptions that should not be rescued by default
        # (if you want to implement custom error handling);
        [:ip_exception, Proc.new { Exception.new }],

        # Allow loopback Ip
        [:allow_loopback, true],

        # cache object (must respond to #[], #[]=, and #keys)
        [:cache, nil],

        # prefix (string) to use for all cache keys
        [:cache_prefix, "ip_filter:"]
      ]
    end

    # define getters and setters for all configuration settings
    self.options_and_defaults.each do |option, default|
      class_eval(<<-END, __FILE__, __LINE__ + 1)

        @@#{option} = default unless defined? @@#{option}

        def self.#{option}
          @@#{option}
        end

        def self.#{option}=(obj)
          @@#{option} = obj
        end

      END
    end
  end
end
