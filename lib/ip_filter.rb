require "ip_filter/configuration"
require "ip_filter/cache"
require "ip_filter/request"
require "ip_filter/lookups/geoip"
require "ip_filter/providers/s3"
require "ip_filter/providers/max_mind"

module IpFilter
  extend self
  attr_accessor :updated_at
  attr_reader :lookups, :refresh_inprogress
  # Search for information about an address.
  def search(query)
    if ip_address?(query) && !query.blank?
      begin
        get_lookup.search(query)
      rescue
        sleep(0.300) #wait to reload the file
        get_lookup.search(query)
      end
    else
      raise ArgumentError, "invalid address"
    end
  end

  # The working Cache object, or +nil+ if none configured.
  def cache
    @cache ||= Configuration.cache
  end

  def s3
    return @s3 if not @s3.nil?
    if !Configuration.s3_access_key_id.nil? and
        !Configuration.s3_secret_access_key.nil?
      return @s3 ||= IpFilter::S3.new
    end
    return @s3
  end

  def maxmind
    @maxmind ||= IpFilter::Providers::MaxMind.new
  end

  def reference_file
    Configuration.geo_ip_dat
  end


  def database_files
    Dir[Configuration.data_folder + '/*.dat']
  end

  private

  def refresh_db
    begin
      IpFilter::Configuration.update_method.call
      IpFilter.cache.reset if !IpFilter.cache.nil?
      @updated_at = Time.now
      @lookups = IpFilter::Lookup::Geoip.new
    ensure
      @refresh_inprogress = false
    end
  end

  # Retrieve a Lookup object from the store.
  def get_lookup
    @updated_at ||= Time.now
    if !@refresh_inprogress && (@lookups.nil? || Time.now.to_i > (@updated_at.to_i + IpFilter::Configuration.refresh_delay))
      @refresh_inprogress = true
      Thread.new {refresh_db}
    end
    @lookups ||= IpFilter::Lookup::Geoip.new
  end

  # Checks if value looks like an IP address.
  #
  # Does not check for actual validity, just the appearance of four
  # dot-delimited numbers.
  def ip_address?(value)
    !!value.to_s.match(/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})(\/\d{1,2}){0,1}$/)
  end
end

if defined?(Rails)
  require "ip_filter/railtie"
  IpFilter::Railtie.insert
end
