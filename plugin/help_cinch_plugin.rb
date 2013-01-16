module TurbotPlugins
  class Help
    include Cinch::Plugin

    PluginHandler.add_plugin(self)

    def self.help
      PluginCommand.new('.help', 'This help display.')
    end

    set :prefix, PREFIX

    match /help$/, method: :help
    def help(m)
      m.reply "Hi, I'm turbot. I know how to respond to many commands (I also accept pull requests for more). For more information on any of them execute .help <command name>."
      m.reply PluginHandler.matchers.join(", ")
    end

    match /help (.+)/, method: :help_command
    def help_command(m, matcher)
      m.reply PluginHandler.command(matcher).display_row.join(' - ')
    end
  end
end
