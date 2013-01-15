require 'open-uri'
require 'json'
require 'uri'

module TurbotPlugins
  class DuckDuckGo
    include Cinch::Plugin
    set :prefix, PREFIX

    match(/help/, method: :help)
    def help(m)
      m.reply ".ddg \x02Search Term\x02 = Perform DDG search."
    end

    match(/ddg (.+)/, method: :search)
    def search(m, query)
      @response = get_json_data("http://api.duckduckgo.com/?" + get_query_string(query))
      m.reply pretty_response
    end

    def get_query_string(query)
      "q=#{CGI.escape(query)}&format=json&no_redirect=1&no_html=1"
    end

    def pretty_response
      [:abstract_text, :abstract_source,
       :answer, :definition, :redirect].collect{|sym| send(sym)}.compact.join("\n")
    end

    def abstract_text
      if @response['AbstractText'] != ''
        @response['AbstractText']
      end
    end

    def abstract_source
      if ['AbstractSource', 'AbstractURL'].all?{|s| @response[s] != ''}
        "#{@response['AbstractSource']}: #{@response['AbstractURL']}"
      end
    end

    def answer
      if @response['Answer'] != ''
        "Answer: #{@response['Answer']}"
      end
    end

    def definition
      if ['DefinitionText','DefinitionURL'].all?{|s| @response[s] != ''}
        "Definition (#{@response['DefinitionURL']}): #{@response['DefinitionURL']}"
      end
    end

    def redirect
      url = @response['Redirect']
      if url != ''
        "url: #{url} - title: #{::UrlHandler::GenericHandler.new(url).title}"
      end
    end

    def get_json_data(url)
      data = open(url).read
      JSON(data)
    end
  end
end

