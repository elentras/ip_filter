require "json"

module IpFilter
  class Cache
    class Redis < IpFilter::Cache

      def reset
        keys = IpFilter::Configuration.cache.keys("ip_filter:*")
        IpFilter::Configuration.cache.del keys if not keys.empty?
      end

      # Read from the Cache.
      def [](ip)
        if value = store.get(key_for(ip))
          value = JSON.parse(value)
          OpenStruct.new(value)
        end
      end

      # Write to the Cache.
      def []=(ip, value)
        store.set(key_for(ip), value.to_json)
      end

    end
  end
end
