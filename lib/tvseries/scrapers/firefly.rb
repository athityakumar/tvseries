
def firefly_scraper filename

    agent = Mechanize.new()

    master_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series = master_list.find { |x| x["filename"] == filename }
    page = agent.get(series["scrape_link"])
    imdb_rating = agent.get(series["imdb_link"]).search(".ratingValue").text.strip.gsub("/10","")
    description = agent.get(series["imdb_link"]).search(".summary_text").text.strip
    episodes = page.search(".description").count - 1
    seasons =  1 # Change this later when seasons > 1
    last_season_index = page.search("table")[0].search("tr").count
    first_season_index = last_season_index - seasons
    season_list = []
    list = []
    season_list.push(0)
    # for i in (first_season_index..last_season_index-1)
    #     season_list.push(season_list.last+page.search("table")[1].search("tr")[2].search("td")[2].text.to_i)
    # end
    # while page.search(".vevent")[episodes].search("td")[6].text == "TBD"
    #     episodes = episodes - 1
    # end

    for i in (0..episodes-1)
        data = {}
        data["description"] = page.search(".description")[i].text
        data["title"] = page.search(".vevent")[i+1].search("td")[0].text.gsub("\"","").gsub(",","")
        data["date"] = page.search(".vevent")[i+1].search("td")[3].text
        data["directed_by"] = page.search(".vevent")[i+1].search("td")[1].text
        data["season"] = (i==0) ? "S01" : ""
        data["episode"] = i+1
        if data["episode"] < 10
            data["episode"] = "E0" + data["episode"].to_s
        else
            data["episode"] = "E" + data["episode"].to_s
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