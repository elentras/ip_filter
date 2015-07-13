require 'ip_filter/cache/dallistore'
require 'ip_filter/cache/redis'

module IpFilter

  # For now just a simple wrapper class for a Memcache client.
  class Cache
    cattr_reader :cached_at
    attr_reader :prefix, :store

    def initialize(store, prefix)
      @store = store
      @prefix = prefix
      @@cached_at ||= DateTime.now
    end

    def fetch
      self.class.fetch!
    end

    def fetch(force = false)
      if force == true or DateTime.now > (@@cached_at + 1.day)
        IpFilter::Configuration.update_method.call
        reset
        @@cached_at = DateTime.now
      end
    end

    # Cache key for a given URL.
    def key_for(ip)
      [prefix, ip].join
    end
  end
end
