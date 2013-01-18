require 'spec_helper'

describe PluginHandler do
  def build_plugin_command
    double('plugin_command', :matchers => rand.to_s, :description => rand.to_s)
  end

  subject(:handler){described_class}
  let(:plugin)        {double('plugin', :commands => build_plugin_command)}
  let(:plugin_without_commands) {double}
  let(:plugin_with_multiple_commands) {double('plugin', :commands => [build_plugin_command, build_plugin_command])}

  context ".plugins" do
    it "should be enumerable." do
      handler.plugins.should respond_to(:each)
    end

    it "should be an array." do
      handler.plugins.should be_kind_of(Array)
    end
  end

  context "plugin dependant methods" do
    let(:loaded_plugins) do
      [plugin, plugin_without_commands, plugin_with_multiple_commands]
    end

    before do
      PluginHandler.stub(:plugins => loaded_plugins)
    end

    context ".add_plugin" do
      it "adds passed item to plugins." do
        handler.add_plugin(plugin)
        handler.plugins.last.should eql(plugin)
      end
    end

    context ".commands" do
      it "should return an array of the commands available." do
        handler.commands.should eql([plugin.commands, *plugin_with_multiple_commands.commands])
      end
    end

    context ".find_command" do
      it "should find the given command." do
        expected_command = plugin.commands
        handler.find_commands(expected_command.matchers).should eql([expected_command])
      end
    end

    context ".matchers" do
      let(:matcher_text) {"SOME TEXT"}

      it "should return an array of all of the PluginCommand#matchers attribute values." do
        handler.commands.each do |command|
          command.should_receive(:matchers).and_return(matcher_text)
        end

        handler.matchers.should eql([matcher_text] * handler.commands.length)
      end
    end
  end
end
