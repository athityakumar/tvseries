require 'mechanize'
require 'json'

agent = Mechanize.new()
filename = ARGV[0]
puts filename
puts "hi"
master_json = ARGV[1]
puts master_json
ARGV.clear

master_list = (File.exists? master_json) ? JSON.parse(File.read(master_json)) : [ ]
puts master_list

series = master_list.find { |x| x[:filename] == filename }
page = agent.get(series[:scrape_link])
imdb_rating = agent.get(series[:imdb_link]).search(".ratingValue").text.strip.gsub("/10","")
episodes = page.search(".vevent").count
seasons =  page.search("table")[0].search("tr").last.search("td")[1].text.to_i
last_season_index = page.search("table")[0].search("tr").count
first_season_index = last_season_index - seasons
season_list = []
list = []
data = {}
season_list.push(0)
season_list.push(-1)
for i in (first_season_index..last_season_index-1)
    season_list.push(season_list.last+page.search("table")[0].search("tr")[2].search("td")[2].text.to_i)
end
season_list.delete(-1)

while page.search(".vevent")[episodes].search("td")[5].text == "TBA"
    episodes = episodes - 1
end

for i in (0..episodes-1)
    data["description"] = page.search(".description")[i].text
    data["title"] = page.search(".vevent")[52].search("td")[1].text.gsub("\"","")
    data["date"] = page.search(".vevent")[52].search("td")[4].text.split("(")[0]
    if i<9 
        data["episode"] = "E0" + (i+1).to_s
    else
        data["episode"] = "E" + (i+1).to_s
    end
    if season_list.include? i
        if season_list.index(i) < 9
            data["season"] = "S0" + (season_list.index(i)+1).to_s
        else
            data["season"] = "S" + (season_list.index(i)+1).to_s
        end
    else
        data["season"] = ""
    end
    list.push(data)
end

series[:imdb_rating] = imdb_rating 
series[:episodes] = episodes
series[:seasons] = seasons

File.open(filename, "w") { |file| file.write(JSON.pretty_generate(list)) }
File.open(master_json, "w") { |file| file.write(JSON.pretty_generate(master_list)) }
