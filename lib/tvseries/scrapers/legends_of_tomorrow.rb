module TVSeries
  module Scrapers
    class LegendsOfTomorrow < Base
      WIKI_LINK      = 'https://en.wikipedia.org/wiki/Legends_of_Tomorrow'.freeze
      IMDB_LINK      = 'http://www.imdb.com/title/tt4532368/'.freeze
      SCRAPE_LINK    = 'https://en.wikipedia.org/wiki/List_of_Legends_of_Tomorrow_episodes'.freeze
      JSON_FILE_PATH = File.join(SERIES_JSON_PATH, 'legends_of_tomorrow.json').freeze
      SHORT_NAME     = 'lot'.freeze

      def scrape
        @season_list = [0, 16, 32, 44]
        @n_episodes -= 1 while @page.search('.vevent')[episodes].search('td')[6].text == 'TBD'

        (0...@n_episodes).each do |i|
          data = collect_data(@page, i)
          data = collect_proper_texts(data, i+1)
          @episodes.push(data)
        end

        @n_seasons = @season_list.count
        post_process
      end

      private

      def collect_data(page, i)
        {
          'description' => page.search('.description')[i-1].text,
          'title'       => page.search('.vevent')[i].search('td')[1].text.delete('\"').delete(','),
          'directed_by' => page.search('.vevent')[i].search('td')[2].text,
          'date'        => page.search('.vevent')[i].search('td')[4].text.split('(')[0],
          'views'       => remove_all_between(page.search('.vevent')[i].search('td')[6].text, '[', ']'),
          'episode'     => i,
          'season'      => ''
        }
      end

      def collect_proper_texts(data, i)
        (0..@season_list.count-2).each do |j|
          data['episode'] = get_episode_text(i-@season_list[j]+1) if i > @season_list[j] && i < @season_list[j+1]
        end

        if @season_list.include? i
          data['season']  = get_season_text(@season_list.index(i)+1)
          data['episode'] = 'E01'
        end

        data
      end
    end
  end
end
