module TVSeries
  module Scrapers
    class Firefly < Base
      WIKI_LINK      = 'https://en.wikipedia.org/wiki/Firefly_(TV_series)'.freeze
      IMDB_LINK      = 'http://www.imdb.com/title/tt0303461/'.freeze
      SCRAPE_LINK    = 'https://en.wikipedia.org/wiki/Firefly_(TV_series)'.freeze
      JSON_FILE_PATH = File.join(File.dirname(__FILE__), '../../assets/firefly.json').freeze
      SHORT_NAME     = 'firefly'.freeze

      def scrape
        @n_seasons = 1 # Change this later when seasons > 1
        (0...@n_episodes).each do |i|
          data = collect_data(@page, i)
          data = collect_proper_texts(data)
          @episodes.push(data)
        end

        post_process
      end

      private

      def collect_data(page, i)
        {
          'description' => page.search('.description')[i].text,
          'title'       => page.search('.vevent')[i+1].search('td')[0].text.delete('\"').delete(','),
          'directed_by' => page.search('.vevent')[i+1].search('td')[1].text,
          'date'        => page.search('.vevent')[i+1].search('td')[3].text,
          'episode'     => i+1,
          'season'      => ''
        }
      end

      def collect_proper_texts(data)
        if data['episode'] == 1
          @n_seasons += 1
          data['season'] = get_season_text(@n_seasons)
        end
        data['episode'] = get_episode_text(data['episode'])
        data
      end
    end
  end
end
