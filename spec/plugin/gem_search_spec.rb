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

  context ".commands" do
    it "should print the plugins help message." do
      plugin.class.commands.first.matchers.should eql(".gem <search term>")
      plugin.class.commands.first.description.should eql("Gem Search")

      plugin.class.commands.last.matchers.should eql(".gem info <search term>")
      plugin.class.commands.last.description.should eql("Gem Info")
    end
  end
end
