require 'spec_helper'

require_relative '../../plugin/reddit_joke_cinch_plugin.rb'

describe TurbotPlugins::RedditJoke do
  subject(:plugin){ described_class.new(double.as_null_object) }
  let(:m) {double}

  context "#joke" do
    let(:reply_text) { "RANDOM JOKE HERE" }
    it "should print out a random joke from reddit." do
      plugin.should_receive(:random_joke).and_return(reply_text)
      m.should_receive(:reply).with(reply_text)
      plugin.joke(m)
    end
  end

  context "#get_jokes" do
    it 'should return and array of jokes.' do
      VCR.use_cassette('reddit_joke') do
        plugin.get_jokes.should be_kind_of(Array)
      end
    end
  end

  context "#help" do
    it "should print the plugins help message." do
      plugin.class.help.matchers.should eql("'.joke me', '.joke'")
      plugin.class.help.description.should eql("Random joke from reddit.com/r/jokes.")
    end
  end
end

