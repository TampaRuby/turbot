require 'spec_helper'

require_relative '../../plugin/chuck_norris_cinch_plugin.rb'

describe TurbotPlugins::ChuckNorris do
  subject(:plugin){ described_class.new(double.as_null_object) }
  let(:m) {double}

  context "#chuck_norris" do
    let(:reply_text) { "Chuck Norris originally wrote the first dictionary. The definition for each word is as follows - A swift roundhouse kick to the face." }
    it "should print out Chuck Norris phrase." do
      m.should_receive(:reply).with(reply_text)
      VCR.use_cassette('chuck_norris'){ plugin.chuck_norris(m)}
    end
  end

  context ".commands" do
    it "Should print the plugin's help message." do
      plugin.class.commands.matchers.should eql("'.chuck norris', '.chuck says', '.chuck'")
      plugin.class.commands.description.should eql("Rockin' Norris Quote")
    end
  end
end
