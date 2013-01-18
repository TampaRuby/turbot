module TurbotPlugins
  class CleverTurbot
    include Cinch::Plugin

    set :prefix, PREFIX

    PluginHandler.add_plugin(self)

    def self.commands
      PluginCommand.new("'.turbot <arg>'", 'Talk to turbot.')
    end

    class CleverbotConversations
      def self.conversations
        @conversations ||= {}
      end

      def self.get_conversation(nick)
        conversation = conversations[nick] || CleverbotConversation.new(:nick => nick)
        reset_stale_conversation(conversation)

        conversation.last_requested = Time.now
        conversation
      end

      def self.reset_stale_conversation(c)
        if c.last_requested < Time.now - 300
          c.client = c.new_client
        end
      end
    end

    class CleverbotConversation
      attr_accessor :last_requested, :nick, :client
      def initialize(opts=nil)
        self.last_requested = opts.fetch(:last_requested, Time.now)
        self.nick  = opts.delete(:nick)
        self.client = opts.fetch(:client, Cleverbot::Client.new)
      end

      def new_client
        Cleverbot::Client.new
      end
    end

    match /turbot (.+$)/i, method: :cleverbot_response
    def cleverbot_response(m, query)
      conversation = CleverbotConversations.get_conversation(m.user.nick)
      m.reply conversation.client.write(query)
    end
  end
end
