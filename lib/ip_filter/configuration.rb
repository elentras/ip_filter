module IpFilter
  class Configuration

    def self.options_and_defaults
      [
        # Folder containing GeoIP database files.
        [:data_folder, "/lib/assets/"],

        # Level of filtering : Country, city...
        [:geoip_level, 'country'],

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
        [:cache_prefix, "ip_filter:"],

        # Configuration path for geoipupdate binary
        [:geoipupdate_config, '/usr/local/etc/GeoIP.conf'],

        ## S3 credentials ##
        # if access_key_id is nil, S3 isn't loaded.
        [:s3_access_key_id, nil],

        # S3 Secret API key
        [:s3_secret_access_key, nil],

        # S3 bucket name
        [:s3_bucket_name, 'ip_filter-geoip'],

        # Cache refresh delay, every 24 hours by default
        [:refresh_delay, 1.day]
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
