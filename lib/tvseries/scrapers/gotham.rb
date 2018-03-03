module TVSeries
  module Scrapers
    class Gotham < Base
      WIKI_LINK      = 'https://en.wikipedia.org/wiki/Gotham_(TV_series)'.freeze
      IMDB_LINK      = 'http://www.imdb.com/title/tt3749900/'.freeze
      SCRAPE_LINK    = 'https://en.wikipedia.org/wiki/List_of_Gotham_episodes'.freeze
      JSON_FILE_PATH = File.join(SERIES_JSON_PATH, 'gotham.json').freeze
      SHORT_NAME     = 'gothem'.freeze

      def scrape
        @season_list.push(0)
        (@first_season_index...@last_season_index).each do |i|
          @season_list.push(@season_list.last+@page.search('table')[0].search('tr')[i].search('td')[2].text.to_i)
        end

        @n_episodes -= 1 while @page.search('.vevent')[@n_episodes].search('td')[5].text == 'TBA'

        (0..episodes).each do |i|
          data = collect_data(@page, i)
          data = collect_proper_texts(data, i)
          @episodes.push(data)
        end

        @n_episodes = @episodes.count
        @n_seasons  = @season_list.count

        post_process
      end

      private

      def collect_data(page, i)
        {
          'description' => page.search('.description')[i].text,
          'title'       => page.search('.vevent')[i].search('td')[1].text.delete('\"'),
          'directed_by' => page.search('.vevent')[i].search('td')[2].text,
          'date'        => page.search('.vevent')[i].search('td')[4].text.split('(')[0],
          'views'       => remove_all_between(page.search('.vevent')[i].search('td')[6].text, '[', ']'),
          'episode'     => i+1,
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
