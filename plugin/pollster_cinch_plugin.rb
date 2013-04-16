module TurbotPlugins
  class Pollster
    include Cinch::Plugin
    set :prefix, PREFIX

    PluginHandler.add_plugin(self)

    def self.commands
    end


    attr_accessor :question

    def set_poll(m, question)
      if authenticated_users.include?(m.user.nick)
        self.question = question
        m.reply "Your poll was successfully created!"
      else
        m.reply "You do not have the correct permissions"
      end
    end

    private

    def authenticated_users
      ['rondale_sc']
    end
  end
end
