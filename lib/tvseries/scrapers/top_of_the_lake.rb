module TVSeries
  module Scrapers
    class TopOfTheLake < Base
      WIKI_LINK      = 'https://en.wikipedia.org/wiki/Top_of_the_Lake'.freeze
      IMDB_LINK      = 'http://www.imdb.com/title/tt2103085/'.freeze
      SCRAPE_LINK    = 'https://en.wikipedia.org/wiki/Top_of_the_Lake'.freeze
      JSON_FILE_PATH = File.join(File.dirname(__FILE__), '../../assets/top_of_the_lake.json').freeze
      SHORT_NAME     = 'totl'.freeze

      def scrape
        infos = page.search('.wikitable')[0..2]
        infos.each do |info|
          @n_episodes = info.search('.summary').count - 1
          @season_list.empty? ? @season_list.push(0) : @season_list.push(@season_list.last+@n_episodes+1)
          ncols = info.search('tr')[0].search('th').count

          (0..episodes).each do |i|
            data = collect_data(info, i, ncols)
            data = collect_proper_texts(data, i)
            @episodes.push(data)
          end
        end

        @n_episodes = @episodes.count
        @n_seasons  = @season_list.count
        post_process
      end

      private

      def collect_data(info, i, ncols)
        {
          'description' => info.search('td')[ncols*i+ncols-1].text,
          'title'       => info.search('td')[ncols*i+1].text.delete('\"'),
          'directed_by' => info.search('td')[ncols*i+2].text,
          'date'        => info.search('td')[ncols*i+4].children[0].text,
          'episode'     => i+1,
          'season'      => ''
        }
      end

      def collect_proper_texts(data, i)
        data['episode'] = get_episode_text(i)

        if @season_list.include? i
          data['season']  = get_season_text(@season_list.index(i)+1)
          data['episode'] = 'E01'
        end

        data
      end
    end
  end
end
