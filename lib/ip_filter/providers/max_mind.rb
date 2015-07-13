require 'fileutils'

module IpFilter
  module Providers
    class MaxMind
      cattr_accessor :files

      def initialize
        check_geoipupdate_presence!
        self.update!
        @files = Dir["#{folder}/*"]
        return @files
      end

      def check_geoipupdate_presence!
        if not %x{command -v geoipupdate >/dev/null 2>&1 || { 'false'>&2; exit 1; }}
          puts 'WARNING: `geoipupdate` binary is required, to setup it do the following :'
          puts 'First, add the maxmind ppa repository: `add-apt-repository ppa:maxmind/ppa`'
          puts 'Next, update your package list: `apt-get update`'
          puts 'Finally, setup the package: `apt-get install geoipupdate`'
          raise "Missing binary : geoipupdate"
        end
        return true
      end

      def self.config
        @config ||= IpFilter::Configuration.geoipupdate_config
      end

      def self.folder
        @folder ||= IpFilter::Configuration.data_folder
      end

      def update!
        self.class.update!
      end

      def self.update!
        # Execute geoipupdate command.
        if %x{geoipupdate -f #{config} -d #{folder}}
          return true
        end
        return false
      end

    end
  end
end
