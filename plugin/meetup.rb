require 'rmeetup'

# Use a gem to access event details from the Meetup API
# https://github.com/Jberlinsky/rmeetup/

module TurbotPlugins
  class Meetup
    include Cinch::Plugin
    set :prefix, PREFIX
    match /nextmeetup/, method: :nextmeetup

    def nextmeetup(m)
      m.reply get_meetup_info
    rescue
      m.reply "Sorry, something went wrong with the lookup."
    end

    def get_meetup_info
      RMeetup::Client.api_key = MEETUP_API_KEY
      response = RMeetup::Client.fetch(:events,{:group_urlname => "tampa-rb"})
      "Next meeting is at #{response[0].event["venue_name"]} starting at #{response[0].event["time"]}. \n #{response[0].event["event_url"]}"
    end
  end
end
