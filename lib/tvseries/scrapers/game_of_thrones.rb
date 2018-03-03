def got_scraper filename

    agent = Mechanize.new()

    master_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series = master_list.find { |x| x["filename"] == filename }
    page = agent.get(series["scrape_link"])
    imdb_rating = agent.get(series["imdb_link"]).search(".ratingValue").text.strip.gsub("/10","")
    description = agent.get(series["imdb_link"]).search(".summary_text").text.strip
    episodes = page.search(".summary").count
    seasons =  page.search("table")[0].search("tr").last.search("td")[1].text.to_i
    last_season_index = page.search("table")[0].search("tr").count
    first_season_index = last_season_index - seasons
    season_list = []
    list = []
    season_list.push(0)
    for i in (first_season_index..last_season_index-1)
        season_list.push(season_list.last+page.search("table")[0].search("tr")[2].search("td")[2].text.to_i)
    end

    for i in (0..episodes-1)
        data = {}
        ep_page = agent.get("https://en.wikipedia.org"+page.search(".summary")[i].search("a")[0]["href"]) rescue next
        data["description"] = ep_page.search("html").text.split("Plot[edit]")[1].split("Production[edit]")[0].strip.gsub("[edit]","").gsub("\n","<br><br>")
        data["description"] = remove_all_between(data["description"],"(",")")
        data["title"] = page.search(".summary")[i].text.gsub("\"","")
        for j in (0..season_list.count-2)
            if i > season_list[j] && i < season_list[j+1]
                data["episode"] = i-season_list[j]+1
                if data["episode"] < 10
                    data["episode"] = "E0" + data["episode"].to_s
                else
                    data["episode"] = "E" + data["episode"].to_s
                end
            end
        end
        if season_list.include? i
            if season_list.index(i) < 10
                data["season"] = "S0" + (season_list.index(i)+1).to_s
            else
                data["season"] = "S" + (season_list.index(i)+1).to_s
            end
            data["episode"] = "E01"
        else
            data["season"] = ""
        end
        list.push(data)
    end

    series["imdb_rating"] = imdb_rating.to_s
    series["episodes"] = episodes.to_s
    series["seasons"] = seasons.to_s
    series["description"] = description

    File.open("../data/#{filename}.json", "w") { |file| file.write(JSON.pretty_generate(list)) }
    File.open($master_json, "w") { |file| file.write(JSON.pretty_generate(master_list)) }



end
