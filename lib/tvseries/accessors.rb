require 'json'

module TVSeries
  class Accessors
    attr_reader :episodes, :seasons, :imdb_rating, :time

    def initialize(series_class_name, series_short_name)
      @series_class_name = series_class_name
      @series_short_name = series_short_name

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


TVSeries::SERIES_KEYWORD_MAPPINGS.each do |short_name, class_name|
  TVSeries.const_set class_name, 'TVSeries::Accessors'.to_class.new(class_name, short_name)
end
