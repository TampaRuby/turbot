require 'spec_helper'

require_relative '../plugin/help_cinch_plugin.rb'
require_relative '../plugin/meetup_cinch_plugin.rb'

describe TurbotPlugins::Help do
  subject(:plugin){ described_class.new(double.as_null_object) }
  let(:m) {double}

  context "#help" do
    it "should print the plugins help message." do
      m.should_receive(:reply).with("+-------------+----------------------------------+\n| Matchers    | Description                      |\n+-------------+----------------------------------+\n| .nextmeetup | Get the next meetup information. |\n+-------------+----------------------------------+")

      plugin.help(m)
    end
  end
end
