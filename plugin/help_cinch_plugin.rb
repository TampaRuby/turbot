module TurbotPlugins
  class Help
    include Cinch::Plugin

    set :prefix, PREFIX

    match /help/, method: :help
    def help(m)
      m.reply pretty_help.to_s
    end

    def pretty_help
      plugin_commands = PluginHandler.plugins.inject([]) {|m,p| m += Array(p.help) }
      rows            = plugin_commands.collect {|c| [c.matchers,c.description]}

      Terminal::Table.new :headings => ['Matchers', 'Description'], :rows => rows
    end
  end
end
