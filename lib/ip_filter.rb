require "ip_filter/configuration"
require "ip_filter/cache"
require "ip_filter/request"
require "ip_filter/lookups/geoip"
require "ip_filter/s3"
require "ip_filter/providers/max_mind"

module IpFilter
  extend self

  # Search for information about an address.
  def search(query)
    if ip_address?(query) && !blank_query?(query)
      get_lookup.search(query)
    else
      raise ArgumentError, "invalid address"
    end
  end

  # The working Cache object, or +nil+ if none configured.
  def cache
    store = Configuration.cache
    if @cache.nil? && (not store.nil?) && IpFilter::Cache.const_defined?(store.class.to_s)
      store_klass = const_get("IpFilter::Cache::#{store.class}")
      @cache = store_klass.new(store, Configuration.cache_prefix)
    end
    @cache
  end

  def s3
    return @s3 if not @s3.nil?
    if Configuration.s3_access_key_id. present? and
      Configuration.s3_secret_access_key.present?
      return @s3 ||= IpFilter::S3.new
    end
    return @s3
  end

  def maxmind
    @maxmind ||= IpFilter::Providers::MaxMind.new
  end

  def reference_file
    return @reference_file if not @reference_file.nil?
    level = Configuration.geoip_level.to_s
    @reference_file = database_files.detect { |f| f.downcase.include?(level) }
  end

  def database_files
    Dir[Configuration.data_folder + '/*.dat']
  end

  private

  # Retrieve a Lookup object from the store.
  def get_lookup
    @lookups ||= IpFilter::Lookup::Geoip.new
  end

  # Checks if value looks like an IP address.
  #
  # Does not check for actual validity, just the appearance of four
  # dot-delimited numbers.
  def ip_address?(value)
    !!value.to_s.match(/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})(\/\d{1,2}){0,1}$/)
  end

  # Checks if value is blank.
  def blank_query?(value)
    !!value.to_s.match(/^\s*$/)
  end
end

if defined?(Rails)
  require "ip_filter/railtie"
  IpFilter::Railtie.insert
end
