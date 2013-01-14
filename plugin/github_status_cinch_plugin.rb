require 'json'
require 'open-uri'

module TurbotPlugins
  class GithubStatus
    include Cinch::Plugin

    set :prefix, PREFIX

    match /help/, :method => :help
    def help(m)
      m.reply ".github status = Show latest status update for Github. (will auto-print every 5 minutes when github is having issues)"
      m.reply ".github last message = Show latest manual status update for Github."
    end

    timer 300, method: :status
    match /github status/, :method => :status
    def status(m=nil)
      data = get_json_data('https://status.github.com/api/status.json')
      message = "github status: \x02#{data['last_updated']}\x02 - \x02#{data['status']}\x02"

      if m
        m.reply message
      else
        if data['status'] != 'good'
          bot.channel_list.each{|c| c.send(message)}
        end
      end
    end

    match /github last message/, :method => :last_message
    def last_message(m)
      data = get_json_data('https://status.github.com/api/last-message.json')
      m.reply "github last message: \x02#{data['created_on']}\x02 - \x02#{data['status']}\x02 - \x02#{data['body']}\x02"
    end

    private

    def get_json_data(url)
      raw = open(url).read
      JSON.parse(raw)
    end
  end
end
