require 'active_support/cache'
require 'ip_filter'
require 'ip_filter/cache'
require 'ip_filter/cache/dallistore'
require 'spec_helper'

describe IpFilter::Cache::DalliStore do
  extend EnableDallistoreCache
  activate_dallistore!

  subject { described_class.new(IpFilter.Configuration.cache) }

  it { expect respond_to(:reset).with(0).arguments }
  it { expect respond_to(:[]).with(1).arguments }
  it { expect respond_to(:[]=).with(2).arguments }

end
