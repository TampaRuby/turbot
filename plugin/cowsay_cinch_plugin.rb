require 'mechanize'

module TurbotPlugins
  class Cowsay
    include Cinch::Plugin
    set :prefix, PREFIX

    PluginHandler.add_plugin(self)

    def self.commands
      PluginCommand.new(".cowsay", "\x02Bovine Phrase\x02 = Awesome Cowsay Graphic")
    end

    match /cowsay (.+)/i, method: :cowsay
    def cowsay(m, text)
      page = agent.get('http://cowsay.morecode.org/say?format=text&message=' + text)
      m.reply page.body
    end

    def agent
      @agent ||= Mechanize.new
    end
  end
end
