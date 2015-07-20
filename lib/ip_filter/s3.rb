require 'aws-sdk'
require 'aws-sdk-v1'

module IpFilter
  class S3
    attr_accessor :remote, :bucket_name, :urls

    def initialize
      @bucket_name = IpFilter::Configuration.s3_bucket_name
      AWS.config(
        :access_key_id => IpFilter::Configuration.s3_access_key_id,
        :secret_access_key => IpFilter::Configuration.s3_secret_access_key
      )
      @remote = AWS::S3.new
      @bucket = create_bucket
      @urls = {}
      return self
    end

    def create_bucket
      bucket = remote.buckets[bucket_name]
      unless bucket.exists?
        bucket = remote.buckets.create(bucket_name)
      end
      return bucket
    end

    def upload!
      IpFilter.database_files.each do |file|
        file_name = File.basename(file)
        puts "upload: #{file_name}"
        obj = @bucket.objects[file_name].write(:file => file)
        urls[file_name] = obj.url_for(:read, expires: Time.now.to_i + 840000)
        puts urls[file_name]
      end
      urls
    end

    def download!(name=nil)
      if name == nil
        name = File.basename(IpFilter::Configuration.geo_ip_dat)
      end
      geoip_db = @bucket.objects[name]
      File.open(IpFilter::Configuration.geo_ip_dat, 'wb') do |file|
        geoip_db.read do |chunk|
          file.write(chunk)
        end
      end
    end
  end
end
