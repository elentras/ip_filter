require "ip_filter/configuration"
require "ip_filter/cache"
require "ip_filter/request"
require "ip_filter/lookups/geoip"

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
    if @cache.nil? && (store = Configuration.cache)
      begin
        store_klass = const_get("IpFilter::Cache::#{store.class}")
        @cache = store_klass.new(store, Configuration.cache_prefix)
      rescue => e
        raise NotImplementedError, store
      end
    end
    @cache
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
