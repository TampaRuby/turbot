# help message

module TurbotPlugins
  class TurbotInfo
    include Cinch::Plugin
    set :prefix, PREFIX

    PluginHandler.add_plugin(self)

    def self.help
      PluginCommand.new(".turbotinfo", "Information about turbot.")
    end

    match /help/, method: :help
    def help(m)
      m.reply ".turbotinfo = Information about Turbot"
    end

    match /turbotinfo/, method: :turbotinfo
    def turbotinfo(m)
      m.reply "The Turbot source code can be found here: http://git.io/turbot"
    end
  end
end
