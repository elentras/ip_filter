require 'ip_filter/cache/dallistore'
require 'ip_filter/cache/redis'

module IpFilter

  # For now just a simple wrapper class for a Memcache client.
  class Cache
    attr_reader :cached_at
    attr_reader :prefix, :store

    def initialize(store, prefix = IpFilter.configuration.cache_prefix)
      @store = store
      @prefix = prefix
      @cached_at ||= DateTime.now
    end

    def serialize_output(value)
      if !value.nil? && value != 'null'
        value = JSON.parse(value)
        return OpenStruct.new(value)
      end
      return nil
    end

    # Cache key for a given URL.
    def key_for(ip)
      [prefix, ip].join
    end
  end
end
