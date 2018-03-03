module TVSeries
  module Scrapers
    class BreakingBad < Base
      WIKI_LINK = ''
      IMDB_LINK = ''
      SCRAPE_LINK = ''
      JSON_FILE = ''

      def scrape
      end
    end
  end
end

def bb_scraper filename

    agent = Mechanize.new()

    master_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series = master_list.find { |x| x["filename"] == filename }
    page = agent.get(series["scrape_link"])
    imdb_rating = agent.get(series["imdb_link"]).search(".ratingValue").text.strip.gsub("/10","")
    description = agent.get(series["imdb_link"]).search(".summary_text").text.strip
    list = []
    episodes = 0
    seasons = 0
    link_list = []
    scrape_link = series["scrape_link"].gsub("http://breakingbad.wikia.com/","")
    while !link_list.include? scrape_link
        data = {}
        link_list.push(scrape_link)
        episodes = episodes + 1
        puts episodes.to_s
        page = agent.get("http://breakingbad.wikia.com/"+scrape_link)
        data["description"] = page.search("html").text.split("Teaser")[1].split("Act I")[0].strip.gsub("[edit]","").gsub("\n","<br><br>").gsub("\t", "")
        data["title"] = page.search(".page-header__title").text
        data["episode"] = page.search(".portable-infobox td")[1].text.to_i
        if data["episode"] == 1
            data["season"] = page.search(".portable-infobox td")[0].text.to_i
            seasons = data["season"]
            if data["season"] < 10
                data["season"] = "S0" + data["season"].to_s
            else
                data["season"] = "S" + data["season"].to_s
            end
        else
            data["season"] = ""
        end
        if data["episode"] < 10
            data["episode"] = "E0" + data["episode"].to_s
        else
            data["episode"] = "E" + data["episode"].to_s
        end
        data["directed_by"] = page.search(".portable-infobox .pi-data-value")[3].text
        data["date"] = page.search(".portable-infobox .pi-data-value")[6].text

        list.push(data)
        scrape_link = page.search(".portable-infobox td a").last["href"][1..-1]
    end

    series["imdb_rating"] = imdb_rating.to_s
    series["episodes"] = episodes.to_s
    series["seasons"] = seasons.to_s
    series["description"] = description

    File.open("../data/#{filename}.json", "w") { |file| file.write(JSON.pretty_generate(list)) }
    File.open($master_json, "w") { |file| file.write(JSON.pretty_generate(master_list)) }

end