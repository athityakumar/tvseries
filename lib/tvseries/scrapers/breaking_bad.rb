module TVSeries
  module Scrapers
    class BreakingBad < Base
      WIKI_LINK      = 'https://en.wikipedia.org/wiki/Breaking_Bad'.freeze
      IMDB_LINK      = 'http://www.imdb.com/title/tt0903747/'.freeze
      SCRAPE_LINK    = 'http://breakingbad.wikia.com/wiki/Pilot'.freeze
      JSON_FILE_PATH = File.join(::SERIES_JSON_PATH, 'breaking_bad.json').freeze
      SHORT_NAME     = 'bb'.freeze

      def scrape
        list_of_links = []
        scrape_link   = SCRAPE_LINK.delete('http://breakingbad.wikia.com/')

        until list_of_links.include?(scrape_link)
          list_of_links.push(scrape_link)
          @n_episodes += 1
          @page = @agent.get("http://breakingbad.wikia.com/#{scrape_link}")
          data = collect_data(@page)
          data = collect_proper_texts(data)
          @episodes.push(data)

          scrape_link = @page.search('.portable-infobox td a').last['href'][1..-1]
        end

        post_process
      end

      private

      def collect_data(page)
        {
          'description' => page.search('html').text.split('Teaser')[1].split('Act I')[0]
                               .strip.delete('[edit]').gsub("\n", '<br><br>').delete("\t"),
          'title'       => page.search('.page-header__title').text,
          'directed_by' => page.search('.portable-infobox .pi-data-value')[3].text,
          'date'        => page.search('.portable-infobox .pi-data-value')[6].text,
          'episode'     => page.search('.portable-infobox td')[1].text.to_i,
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
