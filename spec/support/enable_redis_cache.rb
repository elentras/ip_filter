require 'fakeredis'

module EnableRedisCache
  def activate_redis!
    let(:cache) { Redis.new }

    before do
      allow(IpFilter.configuration).to receive(:cache) { cache }
    end

    after do
      allow(IpFilter.configuration).to receive(:cache) { nil }
    end
  end
end
