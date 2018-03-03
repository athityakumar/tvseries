module TVSeries
  module Scrapers
    class GameOfThrones < Base
      WIKI_LINK = 'https://en.wikipedia.org/wiki/Game_of_Thrones'.freeze
      IMDB_LINK = 'http://www.imdb.com/title/tt0944947/'.freeze
      SCRAPE_LINK = 'https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_episodes'.freeze
      JSON_FILE_PATH = File.join(File.dirname(__FILE__), '../../assets/got.json').freeze
      SHORT_NAME = 'got'.freeze

      def scrape
        @n_episodes = @page.search('.summary').count
        @season_list.push(0)
        (@first_season_index...@last_season_index).each do |i|
          @season_list.push(@season_list.last+@page.search('table')[0].search('tr')[i].search('td')[2].text.to_i)
        end

        (0...@n_episodes).each do |i|
          e_page = @agent.get('https://en.wikipedia.org'+@page.search('.summary')[i].search('a')[0]['href']) rescue next

          data = collect_data(e_page)
          data = collect_proper_texts(data, i)
          @episodes.push(data)
        end

        post_process
      end

      private

      def collect_data(page, i)
        {
          'description' => remove_all_between(
            page.search('html').text.split('Plot[edit]')[1].split('Production[edit]')[0]
                .strip.delete('[edit]').gsub('\n', '<br><br>'),
            '(',
            ')'
          ),
          'title'       => page.search('.summary')[i].text.delete('\"'),
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
