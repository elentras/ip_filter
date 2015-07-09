require "spec_helper"

describe IpFilter do
  context "Methods" do
    context "#ip_address?" do

      it "should success on IP range " do
        expect(
          described_class.send(:"ip_address?", '1.2.3.4/1')
        ).to be_truthy
      end

      it "should success on IP " do
        expect(
          described_class.send(:"ip_address?", '1.2.3.4')
        ).to be_truthy
      end

    end
  end

end
