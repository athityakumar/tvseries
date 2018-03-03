def totl_scraper filename
    agent = Mechanize.new()
    master_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series = master_list.find { |x| x["filename"] == filename }
    page = agent.get(series["scrape_link"])
    imdb_rating = agent.get(series["imdb_link"]).search(".ratingValue").text.strip.gsub("/10","")
    description = agent.get(series["imdb_link"]).search(".summary_text").text.strip
    infos = page.search(".wikitable")[0..2]
    list = []
    season_list = []

    infos.each do |info|
      episodes = info.search(".summary").count - 1
      season_list.empty? ? season_list.push(0) : season_list.push(season_list.last+episodes+1)
      ncols = info.search("tr")[0].search("th").count

      for i in (0..episodes)
          data = {}

          data["description"] = info.search("td")[ncols*i+ncols-1].text
          data["directed_by"] = info.search("td")[ncols*i+2].text
          data["title"] = info.search("td")[ncols*i+1].text.gsub("\"","")
          data["date"] = info.search("td")[ncols*i+4].children[0].text

          # if ncols == 6
          # data["description"] = info.search("td")[6*i+5].text
          # data["directed_by"] = info.search("td")[6*i+2].text
          # data["title"] = info.search("td")[6*i+1].text.gsub("\"","")
          # data["date"] = info.search("td")[6*i+4].text

          # elsif ncols == 7
          # data["description"] = info.search("td")[7*i+6].text
          # data["directed_by"] = info.search("td")[7*i+2].text
          # data["title"] = info.search("td")[7*i+1].text.gsub("\"","")
          # data["date"] = info.search("td")[7*i+4].text
          # end
          j = i+1
          if j < 10
              data["episode"] = "E0" + j.to_s
          else
              data["episode"] = "E" + j.to_s
          end
          if season_list.include? i
              if season_list.count < 10
                  data["season"] = "S0" + (season_list.count).to_s
              else
                  data["season"] = "S" + (season_list.count).to_s
              end
              data["episode"] = "E01"
          else
              data["season"] = ""
          end
          list.push(data)
      end
    end

    seasons = season_list.count
    series["imdb_rating"] = imdb_rating.to_s
    series["episodes"] = list.count.to_s
    series["seasons"] = seasons.to_s
    series["description"] = description

    File.open("../data/#{filename}.json", "w") { |file| file.write(JSON.pretty_generate(list)) }
    File.open($master_json, "w") { |file| file.write(JSON.pretty_generate(master_list)) }


end