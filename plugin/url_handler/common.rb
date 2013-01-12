module TurbotPlugins::UrlHandler
  module Common
    def agent
      @agent ||= Mechanize.new
    end

    def get_json_data(url)
      page = agent.get(url)
      JSON.parse(page.body)
    end
  end
end
