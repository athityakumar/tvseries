require 'mechanize'
require 'json'

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

def wiki2_scraper filename

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

def wiki_scraper filename

    agent = Mechanize.new()

    master_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series = master_list.find { |x| x["filename"] == filename }
    page = agent.get(series["scrape_link"])
    imdb_rating = agent.get(series["imdb_link"]).search(".ratingValue").text.strip.gsub("/10","")
    description = agent.get(series["imdb_link"]).search(".summary_text").text.strip
    episodes = page.search(".description").count
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

def assign_scraper 
    series_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series_list.each do |series|
        send(:"#{series["scrape_script"]}_scraper",series["filename"])
    end
end

def generate_html 
    series_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    master_text = (File.exists? $master_html_segment[0]) ? File.read($master_html_segment[0]) : ''
    series_list.each do |series|
        master_text = master_text + '<div class="ui centered card"><div class="image"><img src="'+series["image"]+'" style="height: 250px;"><div class="ui black ribbon label"><i class="clock icon"></i>'+series["time"]+'</div></div><div class="content"><a  href="'+series["filename"]+'.html" class="header">'+series["name"]+'</a><div class="meta"><div class="ui label">Seasons<div class="detail">'+series["seasons"]+'</div></div><div class="ui label">Episodes<div class="detail">'+series["episodes"]+'</div></div></div></div><a href="'+series["filename"]+'.html"><div class="ui bottom attached button blue"><i class="unhide icon"></i>View more</div></a></div>'
        series_text = (File.exists? $series_html_segment[0]) ? File.read($series_html_segment[0]) : ''
        series_text = series_text + series["name"]
        series_text = series_text + ((File.exists? $series_html_segment[1]) ? File.read($series_html_segment[1]) : '')
        series_text = series_text + series["name"] + '</h1><div class="ui hidden divider"></div><a href="'+series["wiki_link"]+'" target="_blank"><div class="ui animated black vertical button" tabindex="0"><div class="hidden content">Wiki</div><div class="visible content"><i class="wikipedia icon"></i></div></div></a><a href="'+series["imdb_link"]+'" target="_blank"><div class="ui animated black vertical button" tabindex="0"><div class="hidden content">IMDb</div><div class="visible content"><i class="info icon"></i></div></div></a><div class="ui floating theme basic button">IMDb rating : '+series["imdb_rating"]+' / 10</div><br><p>'+series["description"]+'</p></div><br><br><br><br><br><br><div class="advertisement"><div class="ui massive centered rounded bordered image"><img src="'+series["image"]+'">'
        series_text = series_text + ((File.exists? $series_html_segment[2]) ? File.read($series_html_segment[2]) : '')        
        series_json = "../data/" + series["filename"] + ".json"
        series_html = "../../" + series["filename"] + ".html"
        episodes_list = (File.exists? series_json) ? JSON.parse(File.read(series_json)) : [ ]
        episodes_list.each do |episode|
            if episode["season"] != ""
                series_text = series_text + '<h2 class="ui dividing header">'+episode["season"]+'</h2>'
            end
            series_text = series_text + '<div class="no example"><h4 class="ui header">'+episode["episode"]+' - '+episode["title"]+'</h4>'
            if (((episode.keys.include? "date") or (episode.keys.include? "directed_by")) or episode.keys.include? "views") 
                series_text = series_text + '<div class="ui message"><i class="close icon"></i><p>'
            end
            if episode.keys.include? "date"
                series_text = series_text + 'This episode aired on '+episode["date"]+'.'
            end
            if episode.keys.include? "directed_by" 
                series_text = series_text + ' Directed by '+episode["directed_by"]+'.'
            end
            if episode.keys.include? "views"   
                  series_text = series_text + ' Recorded '+episode["views"]+' million views. '
            end
            if (((episode.keys.include? "date") or (episode.keys.include? "directed_by")) or episode.keys.include? "views")   
                series_text = series_text + '</p></div>'
            end
            series_text = series_text + '<div class="ui message"><p>'+episode["description"]+'</p></div></div>'
        end  
        series_text = series_text + ((File.exists? $series_html_segment[3]) ? File.read($series_html_segment[3]) : '')   
        File.open(series_html, "w") { |file| file.write(series_text) }

    end
    master_text = master_text + ((File.exists? $master_html_segment[1]) ? File.read($master_html_segment[1]) : '')
    File.open($master_html, "w") { |file| file.write(master_text) }
end

def generate_resources
    series_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    text = (File.exists? $resources_segment[0]) ? File.read($resources_segment[0]) : ''
    series_list.each do |series|
        text = text + "\n \n###" + series["name"] + " \n- [ ] [Wikipedia Link] (" + series["wiki_link"] + ")\n- [ ] [IMDb Link] (" + series["imdb_link"] + ")\n- [ ] [Episode Synopsis Link] (" + series["scrape_link"] + ")\n"
    end
    File.open($resources, "w") { |file| file.write(text) }
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
    text = (File.exists? $sitemap_segment[0]) ? File.read($sitemap_segment[0]) : ''
    Dir.chdir("../../")
    text = text + generate_sitemap_travel(".","","      ","")
    Dir.chdir("auto/ruby")
    text = text + ((File.exists? $sitemap_segment[1]) ? File.read($sitemap_segment[1]) : '')
    File.open($sitemap, "w") { |file| file.write(text) }
end

$master_json = "../data/index.json"
$master_html = "../../index.html"
$master_html_segment = ["../segments/html/index/1.html","../segments/html/index/2.html"]
$series_html_segment = ["../segments/html/series/1.html","../segments/html/series/2.html","../segments/html/series/3.html","../segments/html/series/4.html"]
$sitemap_segment = ["../segments/md/sitemap/1.md","../segments/md/sitemap/2.md"]
$sitemap = "../../SITEMAP.md"
$resources_segment = ["../segments/md/resources/1.md"]
$resources = "../../RESOURCES.md"

assign_scraper()
generate_html()
generate_resources()
generate_sitemap()
