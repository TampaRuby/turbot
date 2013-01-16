require 'spec_helper'

require_relative '../../plugin/vin_diesel_cinch_plugin.rb'

describe TurbotPlugins::VinDiesel do
  subject(:plugin){ described_class.new(double.as_null_object) }
  let(:m) {double}

  context "#vin_diesel" do
    let(:reply_text) { "Vin Diesel originally wrote the first dictionary. The definition for each word is as follows - A swift roundhouse kick to the face." }
    it "should print out Vin Diesel phrase." do
      m.should_receive(:reply).with(reply_text)
      VCR.use_cassette('vin_diesel'){ plugin.vin_diesel(m)}
    end
  end

  context ".commands" do
    it "returns a PluginCommand instance." do
      command = plugin.class.commands
      command.should be_instance_of(PluginCommand)
      command.matchers.should eql("'.vin diesel', '.vin says', '.vin'")
      command.description.should eql("Rockin' Diesel Quote")
    end
  end
end
