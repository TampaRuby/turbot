require 'mechanize'

module TurbotPlugins
  class Cowsay
    include Cinch::Plugin
    set :prefix, PREFIX

    match /help/, method: :help
    def help(m)
      m.reply ".cowsay \x02Bovine Phrase\x02 = Awesome Cowsay Graphic"
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
