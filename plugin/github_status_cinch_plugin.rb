require 'json'
require 'open-uri'

module TurbotPlugins
  class GithubStatus
    include Cinch::Plugin

    set :prefix, PREFIX

    PluginHandler.add_plugin(self)

    def self.commands
      [PluginCommand.new("'.github status'","Show latest status update for Github. (will auto-print every 5 minutes when github is having issues"),
       PluginCommand.new("'.github last message'","Show latest manual status update for Github.")]
    end

    timer 900, method: :automated_status
    match /github automated status/, method: :automated_status
    def automated_status(m=nil)
      message = "github status: \x02#{last_message['created_on']}\x02 - \x02#{last_message['status']}\x02"

      if last_message != @previous_last_message && !['good','minor'].include?(last_message['status'])
        bot.channel_list.each{|c| c.send(message)}
      end

      @previous_last_message = last_message
    end

    match /github status/, :method => :status
    def status(m)
      data = get_json_data('https://status.github.com/api/status.json')
      message = "github status: \x02#{data['last_updated']}\x02 - \x02#{data['status']}\x02"

      m.reply message
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
