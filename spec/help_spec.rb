require 'spec_helper'

require_relative '../plugin_handler.rb'
require_relative '../plugin/help_cinch_plugin.rb'


class ClassThatRegistersWithPluginHandler
  PluginHandler.add_plugin(self)

  def self.help
    PluginCommand.new(".nextmeetup", 'Get the next meetup information.')
  end
end

describe TurbotPlugins::Help do
  subject(:plugin){ described_class.new(double.as_null_object) }
  let(:m) {double}

  before do
    PluginHandler.stub(:plugins => [ClassThatRegistersWithPluginHandler])
  end

  context "#help" do
    it "should print the plugins help message." do

      m.should_receive(:reply).with("+-------------+----------------------------------+\n| Matchers    | Description                      |\n+-------------+----------------------------------+\n| .nextmeetup | Get the next meetup information. |\n+-------------+----------------------------------+")

      plugin.help(m)
    end
  end
end
