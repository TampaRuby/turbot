require 'spec_helper'

require_relative '../../plugin/gem_search_cinch_plugin.rb'

describe TurbotPlugins::GemSearch do
  subject(:plugin){ TurbotPlugins::GemSearch.new(double.as_null_object) }
  let(:m) {double}

  context "#gemsearch" do
    it "should return a list of gem names." do
      stub_request(:any, "http://rubygems.org/api/v1/search.json?query=mechanize").to_return(:body => [{"name" => "mechanize"}].to_json)
      m.should_receive(:reply) { |arg| arg }
      plugin.gemsearch(m, 'mechanize').should eql("1 results: mechanize")
    end
  end

  context "#help" do
    it "should print the plugins help message." do
      m.should_receive(:reply) { |arg| arg }
      plugin.help(m).should eql(".gem = Gem Search")
    end
  end
end
