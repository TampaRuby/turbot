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

  context "#help" do
    it "should print the plugins help message." do
      m.should_receive(:reply).with(".chuck norris = Rockin' Norris Quote")
      m.should_receive(:reply).with(".chuck says = Rockin' Norris Quote")
      m.should_receive(:reply).with(".chuck = Rockin' Norris Quote")
      plugin.help(m)
    end
  end
end
