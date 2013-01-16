require 'spec_helper'

require_relative '../../plugin/ferengi_rules_cinch_plugin.rb'

describe TurbotPlugins::FerengiRules do
  subject(:plugin){ described_class.new(double.as_null_object) }
  let(:m) {double}

  context "#random_rule" do
    it "returns a random rule." do
      first_result  = plugin.random_rule
      second_result = plugin.random_rule
      first_result.should_not eql(second_result)

      [first_result, second_result].all?{|r| plugin.rules.include?(r)}
    end
  end

  context "#print_random_rule" do
    let(:reply_text) { 'RANDOM RULE'}

    it "should print out a random Ferengi Rule of Acquisition." do
      plugin.should_receive(:random_rule).and_return(reply_text)
      m.should_receive(:reply).with(reply_text)
      plugin.print_random_rule(m)
    end
  end

  context ".commands" do
    it "returns a PluginCommand instance." do
      command = plugin.class.commands
      command.should be_instance_of(PluginCommand)
      command.matchers.should eql(".rule of acquisition")
      command.description.should eql("Print a random Ferengi rule of acquisition.")
    end
  end
end
