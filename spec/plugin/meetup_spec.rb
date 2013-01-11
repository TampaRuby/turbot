require 'spec_helper'

require_relative '../../plugin/meetup_cinch_plugin.rb'

describe TurbotPlugins::Meetup do
  subject(:plugin){ TurbotPlugins::Meetup.new(double.as_null_object) }
  let(:m) {double}

  context "#help" do
    it "responds to .help with information about itself." do
      m.should_receive(:reply) {|arg| arg}

      plugin.help(m).should eql(".nextmeetup = Get the next meetup info")
    end
  end

  context "#nextmeetup" do
    it "retrieves the information about the next tampa.rb meetup." do
      m.should_receive(:reply) {|arg| arg}

      VCR.use_cassette("nextmeetup") do
        test_string = "Next meeting is at 8th Light Offices starting at Thu Jan 17 19:00:00 EST 2013. \n http://www.meetup.com/tampa-rb/events/95635932/"
        plugin.nextmeetup(m).should eql(test_string)
      end
    end
  end
end
