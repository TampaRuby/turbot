module TurbotPlugins
  class Help
    include Cinch::Plugin

    PluginHandler.add_plugin(self)

    def self.commands
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
      m.reply print_table(PluginHandler.find_commands(matcher)).to_s
    end

    def print_table(commands)
      Terminal::Table.new :headings => ['Matchers', 'Description'], :rows => commands.collect{|c| c.display_row}
    end
  end
end
