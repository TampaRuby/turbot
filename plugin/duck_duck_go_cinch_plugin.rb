require 'open-uri'
require 'json'
require 'uri'

module TurbotPlugins
  class DuckDuckGo
    class DuckDuckGoResponse
      attr_accessor :abstract_text, :abstract_source, :abstract_url,
                    :answer, :definition_text, :definition_url,
                    :redirect

      def initialize(response)
        response             = cleanup_values(response)
        self.abstract_text   = response['AbstractText']
        self.abstract_source = response['AbstractSource']
        self.abstract_url    = response['AbstractURL']
        self.answer          = response['Answer']
        self.definition_text = response['DefinitionText']
        self.definition_url  = response['DefinitionURL']
        self.redirect        = response['Redirect']
      end

      def format_abstract_response
        return unless abstract_source && abstract_url

        "#{abstract_source}: #{abstract_url}"
      end

      def format_answer_response
        return unless answer

        "Answer: #{answer}"
      end

      def format_definition_response
        return unless definition_text && definition_url

        "Definition (#{definition_text}): #{definition_url}"
      end

      def format_redirect_response
        return unless redirect

        "url: #{redirect} - title: #{::UrlHandler::GenericHandler.new(redirect).title}"
      end

      def formatted_response
        [format_abstract_response, format_answer_response,
         format_definition_response, format_redirect_response].compact.join("\n")
      end

      def cleanup_values(response)
        cleaned_response = {}
        response.each do |key, value|
          next if value == ''

          cleaned_response[key] = if value.class == String
                                    CGI.unescapeHTML(value)
                                  else
                                    value
                                  end
        end

        cleaned_response
      end
    end

    include Cinch::Plugin
    set :prefix, PREFIX

    PluginHandler.add_plugin(self)

    def self.help
      PluginCommand.new(".ddg", "\x02Search Term\x02 = Perform DDG search.")
    end

    match(/help/, method: :help)
    def help(m)
      m.reply ".ddg \x02Search Term\x02 = Perform DDG search."
    end

    match(/ddg (.+)/, method: :search)
    def search(m, query)
      response = get_response("http://api.duckduckgo.com/?" + get_query_string(query))
      m.reply response.formatted_response
    end

    def get_query_string(query)
      "q=#{CGI.escape(query)}&format=json&no_redirect=1&no_html=1"
    end

    def get_response(url)
      data = open(url).read
      DuckDuckGoResponse.new(JSON.parse(data))
    end
  end
end

