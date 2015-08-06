require 'ip_filter'
require 'ip_filter/cache'
require 'ip_filter/cache/redis'
require 'spec_helper'

describe IpFilter::Cache::Redis do
  let!(:prefix) { IpFilter::Configuration.cache_prefix = 'ip_filter_test:' }

  extend EnableRedisCache
  activate_redis!

  subject { described_class.new(IpFilter::Configuration.cache, prefix) }

  it { expect respond_to(:reset).with(0).arguments }
  it { expect respond_to(:[]).with(1).arguments }
  it { expect respond_to(:[]=).with(2).arguments }

  context '#reset' do
    let!(:post_created_ips) do
      IpFilter.search('100.10.220.10')
      IpFilter.search('55.10.220.10')
      IpFilter.search('125.10.220.10')
      IpFilter.search('200.10.220.10')
    end

    let!(:keys) { IpFilter::Configuration.cache.keys("#{prefix}*") }

    it "should drop all existing cache keys" do
      subject.reset
      expect(
        subject.store.keys("#{prefix}*")
      ).to be_empty
    end

  end

  context '#[] (getter)' do
    let!(:post_saved_ip) { IpFilter.search('55.10.220.10') }

    it "should return result from cache" do
      expected_cache = subject.store.keys("#{prefix}:55.10.220.10")
      expect( expected_cache ).to be_empty
      expect( expected_cache ).not_to include post_saved_ip
    end
  end

  context '#[]= (setter)' do
    it "should return result from cache" do
      subject["55.10.220.10"] = { this: 'is a test'}
      result = subject["55.10.220.10"]
      expect(result).not_to be_empty
      expect(result).to eq({"this" => 'is a test'})
    end
  end

end
