require 'dalli'

module EnableDallistoreCache
  def activate_dallistore!

    let(:cache) { Dalli::Client.new }

    before do
      IpFilter::Configuration.stub(:cache).and_return(cache)
    end

    after do
      IpFilter::Configuration.unstub(:cache)
    end
  end
end
