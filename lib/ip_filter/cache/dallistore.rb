module IpFilter
  class Cache
    class DalliStore < IpFilter::Cache

      # Clean Cache (not available, as DalliStore cannot iterate on cache)
      def reset
        logger.warning "Cannot reset ip_filter cache with DalliStore, you must reset all your cache manually."
      end

      # Read from the Cache.
      def [](ip)
        case
          when store.respond_to?(:read)
            store.read key_for(ip)
          when store.respond_to?(:[])
            store[key_for(ip)]
          when store.respond_to?(:get)
            store.get key_for(ip)
        end
      end

      # Write to the Cache.
      def []=(ip, value)
        case
          when store.respond_to?(:write)
            store.write key_for(ip), value
          when store.respond_to?(:[]=)
            store[key_for(ip)] = value
          when store.respond_to?(:set)
            store.set key_for(ip), value
        end
      end

    end
  end
end
