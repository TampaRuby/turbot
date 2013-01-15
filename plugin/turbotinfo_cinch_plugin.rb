# help message

module TurbotPlugins
  class TurbotInfo
    include Cinch::Plugin
    set :prefix, PREFIX

    PluginHandler.add_plugin(self)

    def self.help
      PluginCommand.new(".turbotinfo", "Information about turbot.")
    end

    match /turbotinfo/, method: :turbotinfo
    def turbotinfo(m)
      m.reply "The Turbot source code can be found here: http://git.io/turbot"
    end
  end
end
