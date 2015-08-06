require 'spec_helper'
require 'action_controller'
require 'ip_filter'
require 'ip_filter/controller/geo_ip_lookup'

class IpController < ::ActionController::Base
  include IpFilter::Controller::GeoIpLookup
  include IpFilter::Request

  validate_ip
  skip_validate_ip :only => [:test_action_skip]

  def test_action
    render :text => "Testing test output"
  end

  def test_action_skip
    render :text => "Testing test output"
  end

end

describe IpController do
  context "ip_validate" do
    before(:each) do
      IpFilter.configuration.ip_whitelist = Proc.new { ["127.0.0.1/24"] }
    end

    it "should validate IP and raise error" do
      expect {
        action_call(IpController, :test_action, :ip => '146.243.3.83')
      }.to raise_error(Exception, /GeoIP/)
    end

    it "should validate IP 127.0.0.1 and success" do
      expect {
        action_call(IpController, :test_action, :ip => '127.0.0.1')
      }.to_not raise_error(Exception)
    end

    it "should validate IP 127.0.0.254 and success" do
      expect {
        action_call(IpController, :test_action, :ip => '127.0.0.254')
      }.to_not raise_error(Exception)
    end


  end
  context "skip_ip_validate" do
    before(:each) do
      IpFilter.configuration.ip_whitelist = Proc.new { ["127.0.0.1/24"] }

    end

    it "should validate IP and raise error" do
      expect {
        action_call(IpController, :test_action_skip, :ip => '146.243.3.83')
      }.to_not raise_error
    end

  end

end
