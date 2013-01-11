require 'rspec'
require 'webmock/rspec'
require 'cinch'

PREFIX = /^\./

require_relative '../../plugin/gem_search.rb'

describe TurbotPlugins::GemSearch do
  context "#gemsearch" do
    before do
      stub_request(:any, "http://rubygems.org/api/v1/search.json?query=mechanize").to_return([{"name" => "mechanize"}])
    end
    let(:fake_bot) { double.as_null_object }
    let(:m) { stub(:reply).as_null_object }

    it "should return a list of gem names." do
      TurbotPlugins::GemSearch.new(fake_bot).gemsearch(m, 'mechanize').should eql('mechanize')
    end
  end
end
