# help message

module TurbotPlugins
  class Help
    include Cinch::Plugin
    set :prefix, PREFIX
    match /help/, method: :help
    match /turbotinfo/, method: :turbotinfo

    def help(m)
      [
        ".gem = Gem Search",
        ".nextmeetup = Get the next meetup info",
        ".turbotinfo = Information about Turbot",
        ".help = This message"
      ].each do |cmd|
        m.reply cmd
      end
    end

    def turbotinfo(m)
      m.reply "The Turbot source code can be found here: http://git.io/turbot"
    end
  end
end
