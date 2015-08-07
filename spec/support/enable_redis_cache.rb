require "fakeredis"

module EnableRedisCache
  def activate_redis!
    let(:cache) { Redis.new }

    before do
      IpFilter.configuration.stub(:cache).and_return(cache)
    end

    after do
      IpFilter.configuration.unstub(:cache)
    end

  end
end
