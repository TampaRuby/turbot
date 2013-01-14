require 'json'
require 'open-uri'

module TurbotPlugins
  class RedditJoke
    include Cinch::Plugin
    set :prefix, PREFIX

    match /help/, method: :help
    def help(m)
      m.reply ".joke me = Random joke from reddit.com/r/jokes"
      m.reply ".joke = Random joke from reddit.com/r/jokes"
    end

    match /joke me/, method: :joke
    match /joke/, method: :joke
    def joke(m)
      m.reply random_joke
    end

    def random_joke
      jokes.sample
    end

    def jokes
      @jokes ||= get_jokes
    end

    def get_jokes
      json_data = open('http://www.reddit.com/r/jokes.json').read
      unformatted_jokes = JSON.parse(json_data)['data']['children']
      unformatted_jokes.collect do |joke|
        if joke['data']['selftext'] =~ /^\.\.\./
          joke['data']['title'].gsub(/\.\.\.$/,'') + joke['data']['selftext'].gsub(/^\.\.\./,'')
        else
          joke['data']['selftext']
        end
      end
    end
  end
end

