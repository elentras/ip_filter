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
        value = store.get(key_for(ip))
        if value != 'null'
          value = JSON.parse(value)
          return OpenStruct.new(value)
        end
        return nil
      end

      # Write to the Cache.
      def []=(ip, value)
        store.set(key_for(ip), value.to_json)
      end

    end
  end
end
