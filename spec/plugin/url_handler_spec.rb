require 'spec_helper'

require_relative '../../plugin/url_handler_cinch_plugin.rb'

describe TurbotPlugins::UrlHandler do
  let(:standard_url_root)  {'https://twitter.com/'}
  let(:hashbang_url_root)  {standard_url_root + '#!/'}
  let(:seconds_in_a_day) {24 * 60 * 60}

  subject(:plugin){ described_class.new(double.as_null_object) }

  context "#listen" do
    context "when no http url is embedded in the message" do
      let(:m) {double('message', :raw => 'no http url found here!!')}
      it "should do nothing." do
        m.should_not_receive(:reply)
        plugin.listen(m)
      end
    end

    context "when a twitter status url is given" do
      let(:status_url) {'rwjblue/status/289796927707545601'}
      let(:reply_text) {"tweet: <\x02@rwjblue\x02> Testing Twitter UrlHandler in Turbot"}

      context "in the standard format" do
        it "it should reply." do
          message = double('message', :raw => standard_url_root + status_url)
          message.should_receive(:reply).with(reply_text)

          VCR.use_cassette('url_handler_twitter_status') { plugin.listen(message) }
        end
      end

      context "in the hashbang format" do
        it "it should reply." do
          message = double('message', :raw => hashbang_url_root + status_url)
          message.should_receive(:reply).with(reply_text)

          VCR.use_cassette('url_handler_twitter_status') { plugin.listen(message) }
        end
      end
    end

    context "when a twitter user url is given" do
      let(:username)  {'rwjblue'}
      let(:reply_text) {"tweeter: \x02@#{username}\x02 (\x02Robert Jackson\x02) | tweets: \x02318\x02, following: \x02147\x02, followers: \x0224\x02"}

      context "in the standard format" do
        it "it should reply." do
          message = double('message', :raw => standard_url_root + username)
          message.should_receive(:reply).with(reply_text)

          VCR.use_cassette("url_handler_twitter_user") { plugin.listen(message) }
        end
      end

      context "in the hashbang format" do
        it "it should reply." do
          message = double('message', :raw => hashbang_url_root + username)
          message.should_receive(:reply).with(reply_text)

          VCR.use_cassette("url_handler_twitter_user") { plugin.listen(message) }
        end
      end
    end

    context "when a github repo url is given" do
      let(:message)    {double('message', :raw => url)}
      let(:reply_text) {"github: \x02rondale-sc/turbot\x02 - Tampa.rb IRC bot. (watchers: \x024\x02, forks: \x021\x02)"}

      context "for the base of a repo" do
        let(:url) {'https://github.com/rondale-sc/turbot'}

        it "should reply." do
          message.should_receive(:reply).with(reply_text)
          VCR.use_cassette('url_handler_github_url') { plugin.listen(message) }
        end
      end

      context "for a file in a repo" do
        let(:url) {'https://github.com/rondale-sc/turbot/turbot.yaml'}

        it "should reply." do
          message.should_receive(:reply).with(reply_text)
          VCR.use_cassette('url_handler_github_url') { plugin.listen(message) }
        end
      end
    end

    context "when a github issue url is given" do
      let(:url)       {'https://github.com/rondale-sc/turbot/issues/36'}
      let(:message)   {double('message', :raw => url)}
      let(:reply_text) {"github issue: \x02rondale-sc/turbot\x02 \x02#36\x02 - Github Links should parse PR/Issue titles"}

      it "should reply." do
        message.should_receive(:reply).with(reply_text)
        VCR.use_cassette('url_handler_github_issue_url') { plugin.listen(message) }
      end
    end

    context "when a github pull request url is given" do
      let(:url)       {'https://github.com/rondale-sc/turbot/pull/32'}
      let(:message)   {double('message', :raw => url)}
      let(:reply_text) {"github pull request: \x02rondale-sc/turbot\x02 \x02#32\x02 - Only fire joke method once for 'joke me' command."}

      it "should reply." do
        message.should_receive(:reply).with(reply_text)
        VCR.use_cassette('url_handler_github_pull_request_url') { plugin.listen(message) }
      end
    end

    context "when a gist url is given" do
      let(:url)       {'https://gist.github.com/4513047'}
      let(:message)   {double('message', :raw => url)}
      let(:reply_text) {"gist: \x02rjackson\x02 forks: \x020\x02 desc:\x02Turbot Rocks!!! Check this out...\x02"}

      it "should reply." do
        message.should_receive(:reply).with(reply_text)
        VCR.use_cassette('url_handler_gist_url') { plugin.listen(message) }
      end
    end

    context "when an image url is given" do
      let(:url)        {'http://farm9.staticflickr.com/8013/7619514930_4a1ed85893_z.jpg'}
      let(:message)    {double('message', :raw => url)}
      let(:reply_text) {"image: \x02image/jpeg\x02 (161 KiB)"}

      it "should reply." do
        message.should_receive(:reply).with(reply_text)
        VCR.use_cassette('url_handler_image_url') { plugin.listen(message) }
      end
    end

    context "when no other formatters match" do
      let(:url)        {'http://jonathan-jackson.net/'}
      let(:message)    {double('message', :raw => url)}
      let(:reply_text) {"title: \x02Run With It\x02"}

      it "should reply." do
        message.should_receive(:reply).with(reply_text)
        VCR.use_cassette('url_handler_generic_url') { plugin.listen(message) }
      end
    end

    context "When a youtube url is given." do
      let(:url)        {'http://www.youtube.com/watch?v=hFzz6EZmkq8'}
      let(:message)    {double('message', :raw => url)}
      let(:reply_text) {"video: \x02The Perfect Guide To Holiday Etiquette\x02 (length: \x02146\x02, views: \x021713769\x02, rating: \x024.8\x02, posted: \x022012-11-20T15:23:36+00:00\x02)"}

      it "Should reply correctly." do
        message.should_receive(:reply).with(reply_text)
        VCR.use_cassette('url_handler_youtube') { plugin.listen(message) }
      end
    end
  end
end
