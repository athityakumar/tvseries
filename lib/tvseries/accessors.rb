require 'json'

module TVSeries
  class Accessors
    attr_reader :episodes, :seasons, :imdb_rating, :time

    def initialize(series_filename)
      @series_filename = series_filename
      json_filepath    = File.join(File.dirname(__FILE__), "../assets/#{series_filename}.json")

      @episodes = JSON.parse(File.read(json_filepath))

      # Get series json file name from class mapping - Done
      # Read json file
      # Store appropriate hash parts into,
      # @episodes, @seasons, @imdb_rating and @time
    end
  end

  # Define TVSeries::BreakingBad to access data stored in assets/bb.json
  # Like,
  # TVSeries::BreakingBad.episodes.first
  # TVSeries::BreakingBad.seasons.first.episodes
  # TVSeries::BreakingBad.imdb_rating
  # TVSeries::BreakingBad.time
end

TVSeries::LIST_OF_SERIES.each do |series_filename|
  class_name = series_filename.underscore_to_camelcase
  TVSeries.const_set class_name, 'TVSeries::Accessors'.to_class.new(series_filename)
end
