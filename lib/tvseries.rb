module TVSeries
  LIST_OF_SERIES = %w[breaking_bad firefly game_of_thrones gotham legends_of_tomorrow person_of_interest sherlock the_flash top_of_the_lake white_collar].freeze

  SERIES_JSON_PATH          = File.join(File.dirname(__FILE__), 'assets').freeze
  MASTER_JSON_PATH          = File.join(SERIES_JSON_PATH, 'base.json').freeze
  MASTER_HTML_PATH          = File.join(File.dirname(__FILE__), '../', 'docs', 'index.html').freeze
  SERIES_HTML_PATH          = File.join(File.dirname(__FILE__), '../', 'docs', 'series').freeze
  MASTER_HTML_TEMPLATE_PATH = File.join(File.dirname(__FILE__), 'templates', 'index.html.erb').freeze
  SERIES_HTML_TEMPLATE_PATH = File.join(File.dirname(__FILE__), 'templates', 'series.html.erb').freeze
end

require 'tvseries/monkeys'
require 'tvseries/accessors'
require 'tvseries/scrapers'
require 'tvseries/generators'
require 'tvseries/version'
