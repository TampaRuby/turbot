require 'spec_helper'

require_relative '../../plugin/github_status_cinch_plugin.rb'

describe TurbotPlugins::GithubStatus do
  subject(:plugin){ described_class.new(double.as_null_object) }
  let(:m) {double}

  context "#status" do
    let(:reply_text) {"github status: \x022013-01-13T07:41:09Z\x02 - \x02good\x02"}

    it "should reply with the current github status." do
      m.should_receive(:reply).with(reply_text)
      VCR.use_cassette('github_status_status'){plugin.status(m)}
    end
  end

  context "#last_message" do
    let(:reply_text) {"github last message: \x022013-01-11T15:02:20Z\x02 - \x02good\x02 - \x02Everything operating normally.\x02"}

    it "should reply with the last human github status update." do
      m.should_receive(:reply).with(reply_text)
      VCR.use_cassette('github_status_last_message'){plugin.last_message(m)}
    end
  end

  context ".commands" do
    it "should send it's help info." do
      plugin.class.commands.first.matchers.should eql("'.github status'")
      plugin.class.commands.first.description.should eql("Show latest status update for Github. (will auto-print every 5 minutes when github is having issues")

      plugin.class.commands.last.matchers.should eql("'.github last message'")
      plugin.class.commands.last.description.should eql("Show latest manual status update for Github.")
    end
  end
end
