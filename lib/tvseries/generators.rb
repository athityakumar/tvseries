require 'erb'

module TVSeries
  class Generators
    def initialize(series_name)
      @series_name          = series_name
      @series_class_name    = @series_name.underscore_to_camelcase
      @series_scraper_class = "TVSeries::Scrapers::#{@series_class_name}".to_class
      @series_json_filepath = File.join(::SERIES_JSON_PATH, "#{@series_name}.html")
      @series_html_filepath = File.join(::SERIES_HTML_PATH, "#{@series_name}.json")
    end

    def update
      delete
      @series_scraper_class.new.scrape
      create
    end

    def create
      series_list   = File.exist? ::MASTER_JSON_PATH ? JSON.parse(File.read(::MASTER_JSON_PATH)) : []
      episodes_list = File.exist? @series_json_filepath ? JSON.parse(File.read(@series_json_filepath)) : []

      master_text = File.exist? ::MASTER_HTML_TEMPLATE_PATH ? ERB.new(File.open(::MASTER_HTML_TEMPLATE_PATH).read, 0, '>').result(binding) : ''
      series_text = File.exist? ::SERIES_HTML_TEMPLATE_PATH ? ERB.new(File.open(::SERIES_HTML_TEMPLATE_PATH).read, 0, '>').result(binding) : ''

      File.open(@series_html_filepath, 'w') { |file| file.write(series_text) }
      File.open(::MASTER_HTML_PATH, 'w')    { |file| file.write(master_text) }

      # Scrape from beginning - Done
      # Create series html file - Done
      # Update main index html file - Done
      # Update json files - Done in scraping part
    end

    def delete
      File.delete(::MASTER_HTML_PATH) if File.exist?(::MASTER_HTML_PATH)
      File.delete(@series_html_filepath) if File.exist?(@series_html_filepath)
      # Delete the series html file
    end
  end
end
