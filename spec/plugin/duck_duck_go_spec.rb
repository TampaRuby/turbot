require 'spec_helper'
require 'pry'

require_relative '../../plugin/duck_duck_go_cinch_plugin'
require_relative '../../plugin/url_handler_cinch_plugin'


describe TurbotPlugins::DuckDuckGo do
  subject(:plugin){ TurbotPlugins::DuckDuckGo.new(double.as_null_object) }
  let(:m) {double}

  context "#search" do
    let(:reply_text) {"url: http://man.cx/grep - title: Manpage for grep - man.cx manual pages"}
    let(:search_term) {"!man grep"}

    it "should print out the response from DDG." do
      m.should_receive(:reply).with(reply_text)
      VCR.use_cassette('duck_duck_go') {plugin.search(m, search_term)}
    end
  end

  context ".commands" do
    it "returns a PluginCommand instance." do
      command = plugin.class.commands
      command.should be_instance_of(PluginCommand)
      command.matchers.should eql(".ddg")
      command.description.should eql("\x02Search Term\x02 = Perform DDG search.")
    end
  end
end

