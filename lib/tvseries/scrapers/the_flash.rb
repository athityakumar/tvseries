
def flash_scraper filename

    agent = Mechanize.new()

    master_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series = master_list.find { |x| x["filename"] == filename }
    page = agent.get(series["scrape_link"])
    imdb_rating = agent.get(series["imdb_link"]).search(".ratingValue").text.strip.gsub("/10","")
    description = agent.get(series["imdb_link"]).search(".summary_text").text.strip
    episodes = page.search(".description").count - 1
    seasons =  page.search("table")[0].search("tr").last.search("td")[1].text.to_i
    last_season_index = page.search("table")[0].search("tr").count
    first_season_index = last_season_index - seasons
    season_list = []
    list = []
    season_list.push(0)
    for i in (first_season_index..last_season_index-1)
        season_list.push(season_list.last+page.search("table")[0].search("tr")[2].search("td")[2].text.to_i)
    end
    while page.search(".vevent")[episodes].search("td")[5].text == "TBA"
        episodes = episodes - 1
    end

    for i in (0..episodes)
        data = {}
        data["description"] = page.search(".description")[i].text
        data["title"] = page.search(".vevent")[i].search("td")[1].text.gsub("\"","")
        data["date"] = page.search(".vevent")[i].search("td")[4].text.split("(")[0]
        data["directed_by"] = page.search(".vevent")[i].search("td")[2].text
        data["views"] = page.search(".vevent")[i].search("td")[6].text
        data["views"] = remove_all_between(data["views"],"[","]")
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
    series["episodes"] = (episodes+1).to_s
    series["seasons"] = seasons.to_s
    series["description"] = description

    File.open("../data/#{filename}.json", "w") { |file| file.write(JSON.pretty_generate(list)) }
    File.open($master_json, "w") { |file| file.write(JSON.pretty_generate(master_list)) }


end