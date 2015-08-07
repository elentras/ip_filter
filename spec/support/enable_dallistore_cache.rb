require 'dalli'

module EnableDallistoreCache
  def activate_dallistore!
    let(:cache) { Dalli::Client.new }

    before do
      allow(IpFilter.configuration).to receive_messages(cache: cache)
    end

    after do
      allow(IpFilter.configuration).to receive_messages(cache: nil)
    end
  end
end
