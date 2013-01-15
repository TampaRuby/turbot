require 'set'

module TurbotPlugins
  class MakeMeASandwich
    include Cinch::Plugin
    set :prefix, PREFIX

    PluginHandler.add_plugin(self)

    OKAY  = "Okay."
    WHAT  = "What? Make it yourself"
    BLANK = ""

    def self.help
      PluginCommand.new("'.make me a sandwich'", "Request a tasty sandwich")
    end

    match /make me a sandwich/,      method: :make_me_a_sandwich
    match /sudo make me a sandwich/, method: :sudo_make_me_a_sandwich

    def make_me_a_sandwich(m)
      if user_sudoed_for_sandwich?(m.user)
        m.reply OKAY
        forget_sudoer(m.user)
      else
        m.reply WHAT
      end
    end

    def sudo_make_me_a_sandwich(m)
      record_sudoer(m.user)
      m.reply BLANK
    end

    def record_sudoer(sudoer)
      sudoers << sudoer
    end

    def user_sudoed_for_sandwich?(user)
      sudoers.include?(user)
    end

    def forget_sudoer(user)
      sudoers.delete(user)
    end

    def sudoers
      @sudoers ||= Set.new
    end
  end
end

