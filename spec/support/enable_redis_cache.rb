require "fakeredis"

module EnableRedisCache
  def activate_redis!
    let(:cache) { Redis.new }

    before do
      IpFilter::Configuration.stub(:cache).and_return(cache)
    end

    after do
      IpFilter::Configuration.unstub(:cache)
    end

  end
end
