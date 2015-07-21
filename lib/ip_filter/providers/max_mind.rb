require 'fileutils'

module IpFilter
  module Providers
    class MaxMind
      attr_reader :files

      def initialize
        check_geoipupdate_presence!
        refresh_file_list!
        update! if @files.empty?
        return @files
      end

      def update!
        # Execute geoipupdate command.
        if %x{geoipupdate -f #{config} -d #{folder}}
          refresh_file_list!
          return true
        end
        return false
      end

      def config
        @config ||= IpFilter::Configuration.geoipupdate_config
      end

      def folder
        @folder ||= IpFilter::Configuration.data_folder
      end

      def refresh_file_list!
        @files = Dir["#{folder}/*.dat"]
      end

      protected

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


    end
  end
end
