require 'ip_filter'
require 'ip_filter/providers/max_mind'

describe IpFilter::Providers::MaxMind do
  subject { IpFilter::Providers::MaxMind.new }

  it { expect respond_to(:update!).with(0).argument }
  it { expect respond_to(:config).with(0).argument }
  it { expect respond_to(:folder).with(0).argument }
  it { expect respond_to(:refresh_file_list).with(0).argument }

end
