require "json"

module IpFilter
  class Cache
    class Redis < IpFilter::Cache

      def reset
        keys = store.keys("#{@prefix}*")
        store.del keys if not keys.empty?
      end

      # Read from the Cache.
      def [](ip)
        value = store.get(key_for(ip))
        if !value.nil? && value != 'null'
          return JSON.parse(value)
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
