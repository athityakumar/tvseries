require 'erb'

module TVSeries
  class Generators
    MASTER_JSON_PATH          = File.join(File.dirname(__FILE__), '../assets/base.json')
    MASTER_HTML_TEMPLATE_PATH = File.join(File.dirname(__FILE__), '../templates/index.html.erb')
    SERIES_HTML_TEMPLATE_PATH = File.join(File.dirname(__FILE__), '../templates/series.html.erb')

    def initialize(series_short_name)
      @series_short_name = series_short_name
      @series_class_name = ::SERIES_KEYWORD_MAPPINGS[series_short_name]
    end

    def update
      delete
      create
    end

    def create
      # Scrape from beginning
      # Create series html file
      # Update main index html file
      # Update json files
    end

    def delete
      # Delete the series html file
    end
  end
end

def generate_html
    series_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    master_text = (File.exists? $master_html_template) ? ERB.new(File.open($master_html_template).read, 0, '>').result(binding) : ""
    series_list.each do |series|
        series_json = "../data/" + series["filename"] + ".json"
        series_html = "../../series/" + series["filename"] + ".html"
        episodes_list = (File.exists? series_json) ? JSON.parse(File.read(series_json)) : [ ]
        series_text = (File.exists? $series_html_template) ? ERB.new(File.open($series_html_template).read, 0, '>').result(binding) : ""
        File.open(series_html, "w") { |file| file.write(series_text) }

    end
    File.open($master_html, "w") { |file| file.write(master_text) }
end


$master_json = "../data/index.json"
$master_html = "../../index.html"
$master_html_template = "../segments/html/index.html.erb"
$series_html_template = "../segments/html/series.html.erb"


