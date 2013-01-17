require 'spec_helper'

require_relative '../../plugin/help_cinch_plugin.rb'

class ClassThatRegistersWithPluginHandler
  PluginHandler.add_plugin(self)

  def self.commands
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
      m.should_receive(:reply).with("Hi, I'm turbot. I know how to respond to many commands (I also accept pull requests for more). For more information on any of them execute .help <command name>.")
      m.should_receive(:reply).with(".nextmeetup")

      plugin.help(m)
    end
  end

  context "#help_command" do
    it "should print the detailed help for the given matcher." do
      m.should_receive(:reply).with("+-------------+----------------------------------+\n| Matchers    | Description                      |\n+-------------+----------------------------------+\n| .nextmeetup | Get the next meetup information. |\n+-------------+----------------------------------+")
      plugin.help_command(m, '.nextmeetup')
    end
  end
end
