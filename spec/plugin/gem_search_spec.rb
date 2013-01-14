require 'spec_helper'

require_relative '../../plugin/gem_search_cinch_plugin.rb'

describe TurbotPlugins::GemSearch do
  subject(:plugin){ TurbotPlugins::GemSearch.new(double.as_null_object) }
  let(:m) {double}
  let(:gem) {'hippo'}

  context "#gem_info" do
    let(:reply_text) {"gem: \x02hippo\x02 desc: \x02HIPAA Transaction Set Generator/Parser\x02 ver: \x020.5.1\x02 url: \x02http://github.com/promedical/hippo\x02"}

    it "should print out information for the requested gem." do
      m.should_receive(:reply).with(reply_text)
      VCR.use_cassette('gem_search_info') {plugin.gem_info(m, gem)}
    end
  end

  context "#gemsearch" do
    let(:reply_text) {"gems: #{gem}"}
    it "should return a list of gem names." do
      m.should_receive(:reply).with(reply_text)
      VCR.use_cassette('gem_search_search') {plugin.gemsearch(m, gem)}
    end
  end

  context "#help" do
    it "should print the plugins help message." do
      m.should_receive(:reply).with(".gem \x02Search Term\x02 = Gem Search")
      m.should_receive(:reply).with(".gem info \x02Gem Name\x02 = Gem Info")

      plugin.help(m)
    end
  end
end
