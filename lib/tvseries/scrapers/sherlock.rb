module TVSeries
  module Scrapers
    class Sherlock < Base
      WIKI_LINK      = 'https://en.wikipedia.org/wiki/Sherlock_(TV_series)'.freeze
      IMDB_LINK      = 'http://www.imdb.com/title/tt1475582/'.freeze
      SCRAPE_LINK    = 'https://en.wikipedia.org/wiki/List_of_Sherlock_episodes'.freeze
      JSON_FILE_PATH = File.join(JSON_FILE_PATH, 'sherlock.json').freeze
      SHORT_NAME     = 'sherlock'.freeze

      def scrape
        @season_list.push(0)
        (@first_season_index...@last_season_index).each do |i|
          @season_list.push(@season_list.last+@page.search('table')[0].search('tr')[i].search('td')[2].text.to_i)
        end

        @n_episodes -= 1 while @page.search('.vevent')[@n_episodes].search('td')[5].text == 'TBA'

        (0...@n_episodes).each do |i|
          data = collect_data(@page, i<6 ? i : i+1)
          data = collect_proper_texts(data, i)
          @episodes.push(data)
        end

        @n_seasons = @season_list.count
        post_process
      end

      private

      def collect_data(page, i)
        {
          'description' => remove_all_between(page.search('.description')[i].text, '[', ']'),
          'title'       => remove_all_between(page.search('.vevent')[i].search('td')[1].text.delete('\"'), '[', ']'),
          'directed_by' => page.search('.vevent')[i].search('td')[1].text,
          'date'        => page.search('.vevent')[i].search('td')[4].text.split('(')[0],
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
