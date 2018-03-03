require 'mechanize'

module TVSeries
  module Scrapers
    class Base
      MASTER_JSON_PATH = File.join(File.dirname(__FILE__), '../../assets/base.json')

      def initialize
        @episodes    = []
        @season_list = []

        @master_list = JSON.parse(File.read(MASTER_JSON_PATH))
        @series      = @master_list.find { |series| series['filename'] == SHORT_NAME }
        @agent       = Mechanize.new
        @page        = @agent.get(SCRAPE_LINK)
        @n_episodes = @page.search('.description').count - 1 rescue 0
        @n_seasons  = @page.search('table')[0].search('tr').last.search('td')[1].text.to_i rescue 0

        @last_season_index  = @page.search('table')[0].search('tr').count
        @first_season_index = @last_season_index - @n_seasons

        @imdb_rating = @agent.get(IMDB_LINK).search('.ratingValue').text.strip.delete('/10')
        @description = @agent.get(IMDB_LINK).search('.summary_text').text.strip
      end

      def post_process
        @series['imdb_rating'] = @imdb_rating.to_s
        @series['episodes']    = @n_episodes.to_s
        @series['seasons']     = @n_seasons.to_s
        @series['description'] = @description

        update_local_json
        update_global_json
      end

      def update_local_json
        File.open(JSON_FILE_PATH, 'w') { |file| file.write(JSON.pretty_generate(@episodes)) }
      end

      def update_global_json
        File.open(MASTER_JSON_PATH, 'w') { |file| file.write(JSON.pretty_generate(@master_list)) }
      end

      private

      def internet_connection_exists?(website='https://www.google.com/')
        begin
          @agent.get(website)
        rescue
          puts 'No internet connection found, aborting.'
          return false
        end
        puts 'Internet connection successful, starting the scraping process.'
        true
      end

      def get_season_text(season)
        season < 10 ? "S0#{season}" : "S#{season}"
      end

      def get_episode_text(episode)
        episode < 10 ? "E0#{season}" : "E#{season}"
      end

      def remove_all_between(string, char1, char2)
        while string.index(char1) && string.index(char2)
          index1 = string.index(char1)
          index2 = string.index(char2)
          string = string[0...index1] + string[index2+1..-1]
        end

        string
      end
    end
  end
end
