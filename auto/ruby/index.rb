require 'mechanize'
require 'json'
require 'erb'

def remove_all_between x , c1 , c2
    for i in 0..x.length-1
        if x[i] == c1
            while x[i] != c2
                x.slice!(i)
            end
            x.slice!(i)
        end
    end
    return x
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
        data["description"] = page.search("html").text.split("Teaser")[1].split("Summary")[0].strip.gsub("[edit]","").gsub("\n","<br><br>")
        data["title"] = page.search(".bgbb .textshadow").text.gsub(".","").gsub("'","")
        data["episode"] = page.search(".bgbb td")[3].text.to_i
        if data["episode"] == 1
            data["season"] = page.search(".bgbb td")[2].text.to_i
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
        data["date"] = page.search(".bgbb td")[5].text

        list.push(data)
        scrape_link = page.search(".bgbb td a").last["href"]
    end

    series["imdb_rating"] = imdb_rating.to_s
    series["episodes"] = episodes.to_s
    series["seasons"] = seasons.to_s
    series["description"] = description

    File.open("../data/#{filename}.json", "w") { |file| file.write(JSON.pretty_generate(list)) }
    File.open($master_json, "w") { |file| file.write(JSON.pretty_generate(master_list)) }

end


def poi_scraper filename

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
        ep_page = agent.get("https://en.wikipedia.org"+page.search(".summary")[i].search("a")[0]["href"])
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

def whitecollar_scraper filename

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

def gotham_scraper filename

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




def lot_scraper filename

    agent = Mechanize.new()

    master_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series = master_list.find { |x| x["filename"] == filename }
    page = agent.get(series["scrape_link"])
    imdb_rating = agent.get(series["imdb_link"]).search(".ratingValue").text.strip.gsub("/10","")
    description = agent.get(series["imdb_link"]).search(".summary_text").text.strip
    episodes = page.search(".description").count
    seasons =  page.search("table")[1].search("tr").last.search("td")[1].text.to_i
    last_season_index = page.search("table")[0].search("tr").count
    first_season_index = last_season_index - seasons
    season_list = []
    list = []
    season_list.push(0)
    for i in (first_season_index..last_season_index-1)
        season_list.push(season_list.last+page.search("table")[1].search("tr")[2].search("td")[2].text.to_i)
    end
    while page.search(".vevent")[episodes].search("td")[6].text == "TBD"
        episodes = episodes - 1
    end

    for i in (0..episodes-1)
        data = {}
        data["description"] = page.search(".description")[i].text
        data["title"] = page.search(".vevent")[i+1].search("td")[1].text.gsub("\"","").gsub(",","")
        data["date"] = page.search(".vevent")[i+1].search("td")[4].text.split("(")[0]
        data["directed_by"] = page.search(".vevent")[i+1].search("td")[2].text
        data["views"] = page.search(".vevent")[i+1].search("td")[6].text
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
def sherlock_scraper filename
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

    for i in (0..5)
        data = {}
        data["description"] = page.search(".description")[i].text
        data["description"] = remove_all_between(data["description"],"[","]")
        data["title"] = page.search(".vevent")[i].search("td")[1].text.gsub("\"","")
        data["title"] = remove_all_between(data["title"],"[","]")
        data["date"] = page.search(".vevent")[i].search("td")[4].text.split("(")[0]
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

    for i in (6..episodes-1)
        data = {}
        data["description"] = page.search(".description")[i+1].text
        data["description"] = remove_all_between(data["description"],"[","]")
        data["title"] = page.search(".vevent")[i+1].search("td")[1].text.gsub("\"","")
        data["title"] = remove_all_between(data["title"],"[","]")
        data["date"] = page.search(".vevent")[i+1].search("td")[4].text.split("(")[0]
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
def totl_scraper filename
    agent = Mechanize.new()
    master_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series = master_list.find { |x| x["filename"] == filename }
    page = agent.get(series["scrape_link"])
    imdb_rating = agent.get(series["imdb_link"]).search(".ratingValue").text.strip.gsub("/10","")
    description = agent.get(series["imdb_link"]).search(".summary_text").text.strip
    info = page.search(".wikitable")[0]
    episodes = info.search(".summary").count - 1
    seasons =  1
    season_list = []
    list = []
    season_list.push(0)
    for i in (0..episodes)
        data = {}
        data["description"] = info.search("td")[5*i+4].text
        data["directed_by"] = info.search("td")[5*i+2].text
        data["title"] = info.search("td")[5*i].text.gsub("\"","")
        data["date"] = info.search("td")[5*i+3].children[1].text
        j = i+1
        if j < 10
            data["episode"] = "E0" + j.to_s
        else
            data["episode"] = "E" + j.to_s
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



def assign_scraper
    series_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series_list.each do |series|
        send(:"#{series["filename"]}_scraper",series["filename"])
    end
end

def generate_html
    series_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    master_text = (File.exists? $master_html_template) ? ERB.new(File.open($master_html_template).read, 0, '>').result(binding) : ""
    series_list.each do |series|
        series_json = "../data/" + series["filename"] + ".json"
        series_html = "../../series/" + series["filename"] + ".html"
        episodes_list = (File.exists? series_json) ? JSON.parse(File.read(series_json)) : [ ]
        series_text = (File.exists? $series_html_template) ? ERB.new(File.open($series_html_template).read, 0, '>').result(binding) : ""
        File.open(series_html, "w") { |file| file.write(series_text) }

    end
    File.open($master_html, "w") { |file| file.write(master_text) }
end

def generate_readme

    sitemap_text , resources_text = generate_sitemap() , generate_resources()
    readme_text = (File.exists? $readme_template) ? ERB.new(File.open($readme_template).read, 0, '>').result(binding) : ""
    File.open($readme, "w") { |file| file.write(readme_text) }


end

def generate_resources
    series_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    text = ""
    series_list.each do |series|
        text = text + "\n \n###" + series["name"] + " \n- [ ] [Wikipedia Link] (" + series["wiki_link"] + ")\n- [ ] [IMDb Link] (" + series["imdb_link"] + ")\n- [ ] [Episode Synopsis Link] (" + series["scrape_link"] + ")\n"
    end
    return text
end

def generate_sitemap_sort array
    files , dirs = [] , []
    array.delete(".")
    array.delete("..")
    array.delete(".git")
    array.each do |a|
        if a.include? "."
            files.push(a)
        else
            dirs.push(a)
        end
    end
    files , dirs = files.sort , dirs.sort
    return dirs+files
end

def generate_sitemap_travel repo , spacing , extra_spacing, text
    list = generate_sitemap_sort(Dir.entries(repo))
    list.each do |l|
        if l.include? "."
            if l == list.last
                text = text + "\n" + spacing + l + "\n"
            elsif l == list.first
                text = text + "\n\n" + spacing + l
            else
                text = text + "\n" + spacing + l
            end
        else
            if l == list.first
                text = text + "\n\n" + spacing + l +"/"
            else
                text = text + "\n" + spacing + l +"/"
            end
            text = generate_sitemap_travel(repo+"/"+l,spacing+extra_spacing,extra_spacing,text)
        end
    end
    return text
end

def generate_sitemap
    Dir.chdir("../../")
    text = generate_sitemap_travel(".","","      ","")
    Dir.chdir("auto/ruby")
    return text
end

$master_json = "../data/index.json"
$master_html = "../../index.html"
$master_html_template = "../segments/html/index.html.erb"
$series_html_template = "../segments/html/series.html.erb"
$readme = "../../README.md"
$readme_template = "../segments/md/README.md.erb"

def internet_connection_test website
    agent = Mechanize.new()
    begin
        agent.get(website)

    rescue Exception => e
        puts "No connection"
        return false
    end
    puts "Connection"
    return true
end

if internet_connection_test("https://www.google.com/")
    assign_scraper()
end

generate_html()
generate_readme()
