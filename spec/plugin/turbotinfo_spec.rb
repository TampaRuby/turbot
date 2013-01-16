require 'spec_helper'

require_relative '../../plugin/turbotinfo_cinch_plugin.rb'

describe TurbotPlugins::TurbotInfo do
  subject(:plugin) {TurbotPlugins::TurbotInfo.new(double.as_null_object) }
  let(:m) { double }

  context "#commands" do
    it "should return the help text for itself." do
      plugin.class.commands.matchers.should eql(".turbotinfo")
      plugin.class.commands.description.should eql("Information about turbot.")
    end
  end

  context "#turbotinfo" do
    it "tells you how to get to turbots source." do
      m.should_receive(:reply) { |arg| arg }

      plugin.turbotinfo(m).should eql("The Turbot source code can be found here: http://git.io/turbot")
    end
  end
end
