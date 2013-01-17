require 'spec_helper'

require_relative '../../plugin/clever_turbot_cinch_plugin.rb'

describe TurbotPlugins::CleverTurbot do
  subject(:plugin){ described_class.new(double.as_null_object) }
  let(:m) {double(:user => stub(:nick => "testnick"))  }

  context ".commands" do
    it "returns a PluginCommand instance." do
      command = plugin.class.commands
      command.should be_instance_of(PluginCommand)
      command.matchers.should eql("'.turbot <arg>'")
      command.description.should eql('Talk to turbot.')
    end
  end

  context "#cleverbot_response" do
    it "should return a response from cleverbot" do
      m.should_receive(:reply) {|arg| arg}

      VCR.use_cassette("clever_turbot") do
        plugin.cleverbot_response(m, "Hello?").should eql("Why do you keep saying hello?")
      end
    end
  end

  context 'CleverbotConversations' do
    subject(:cleverbot_conversations) { TurbotPlugins::CleverTurbot::CleverbotConversations }

    it "should instantiate a memoized hash to contain conversations." do
      cleverbot_conversations.conversations.should be_a_kind_of(Hash)

      cleverbot_conversations.conversations["testnick"] = "test"
      cleverbot_conversations.conversations["testnick"].should eql("test")
    end

    context "#get_conversation" do
      let(:existant_conversation) { TurbotPlugins::CleverTurbot::CleverbotConversation.new(:nick => "test_nick") }
      let(:sample_conversations) { {"testnick" => existant_conversation} }

      before do
        cleverbot_conversations.should_receive(:conversations).and_return(sample_conversations)
        cleverbot_conversations.should_receive(:reset_stale_conversation)
      end

      it "should return a valid conversation" do
        cleverbot_conversations.get_conversation("test_nick").should be_a(TurbotPlugins::CleverTurbot::CleverbotConversation)
      end

      it "should update the last_requested field" do
        earlier = existant_conversation.last_requested
        cleverbot_conversations.get_conversation("test_nick").last_requested.should_not eql(earlier)
      end
    end

    context "#reset_stale_conversation" do
      let(:expired_conversation) { TurbotPlugins::CleverTurbot::CleverbotConversation.new(:nick => "test_nick", :last_requested => Time.now - 301) }

      it "should provide a new client if last_requested is older than 5 minutes." do
        initial_client = expired_conversation.client
        expired_conversation.should_receive(:new_client)

        cleverbot_conversations.reset_stale_conversation(expired_conversation)
      end
    end
  end
end
