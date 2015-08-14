module IpFilter
  module Controller
    module GeoIpLookup

      # Mix below class methods into ActionController.
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend, ClassMethods
      end

      #
      # Class methods
      #
      module ClassMethods
        def validate_ip(filter_options = {}, &block)
          if block
            before_filter filter_options do |controller|
              controller.check_ip_location(block)
            end
          else
            before_filter :check_ip_location, filter_options
          end
        end

        def skip_validate_ip(filter_options = {})
          skip_before_filter(:check_ip_location, filter_options)
        end

        def code_type
          @code_type ||= IpFilter.configuration.ip_code_type.to_sym
        end

        def codes
          IpFilter.configuration.ip_codes.call
        end

        def whitelist
          IpFilter.configuration.ip_whitelist.call
        end

        def allow_loopback?
          @allow_loopback ||= IpFilter.configuration.allow_loopback
        end
      end

      #
      # Instance methods
      #
      module InstanceMethods
        private

        def check_ip_location(block = nil)
          code  = request.location[self.class.code_type]
          ip    = request.remote_ip || request.ip

          perform_check = self.class.allow_loopback? ? (code != "N/A") : true

          if perform_check
            unless valid_code?(code) || valid_ip?(ip)
              block ? block.call : IpFilter.configuration.ip_exception.call
            end
          end
        end

        def valid_code?(code)
          code.in? self.class.codes
        end

        def valid_ip?(ip)
          #go through each IP range and validate IP against it
          Array.wrap(self.class.whitelist).any? do |ip_range|
            IPAddr.new(ip_range).include?( ip )
          end
        end

      end


      #end of module
    end
  end
end
