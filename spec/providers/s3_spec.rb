require 'ip_filter'
require 'ip_filter/providers/s3'

describe IpFilter::Providers::S3 do
  it { expect respond_to(:new).with(0).argument }
  it { expect respond_to(:upload!).with(0).argument }
  it { expect respond_to(:create_bucket).with(0).argument }
  it { expect respond_to(:download!).with(0).argument }
  it { expect respond_to(:download!).with(1).argument }
  it { expect respond_to(:refresh_file_list).with(0).argument }
end
