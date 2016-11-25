require 'json'

def assign_scraper 
    series_list = (File.exists? $master_json) ? JSON.parse(File.read($master_json)) : [ ]
    series_list.each do |series|
        `ruby #{series["scrape_script"]} #{series["filename"]} #{series["scrape_link"]} #{$master_json}`  
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
        series_text = series_text + series["name"] + '</h1><div class="ui hidden divider"></div><a href="'+series["wiki_link"]+'" target="_blank"><div class="ui animated black vertical button" tabindex="0"><div class="hidden content">Wiki</div><div class="visible content"><i class="wikipedia icon"></i></div></div></a><a href="'+series["imdb_link"]+'" target="_blank"><div class="ui animated black vertical button" tabindex="0"><div class="hidden content">IMDb</div><div class="visible content"><i class="info icon"></i></div></div></a><div class="ui floating theme basic button">IMDb rating : '+series["imdb_rating"]+' / 10</div><br><p>'+series["description"]+'</p></div><div class="advertisement"><div class="ui massive centered rounded bordered image"><img src="'+series["image"]+'">'
        series_text = series_text + ((File.exists? $series_html_segment[2]) ? File.read($series_html_segment[2]) : '')        
        series_json = "../data/" + series["filename"] + ".json"
        series_html = "../../" + series["filename"] + ".html"
        episodes_list = (File.exists? series_json) ? JSON.parse(File.read(series_json)) : [ ]
        episodes_list.each do |episode|
            if episode["season"] != ""
                series_text = series_text + '<h2 class="ui dividing header">'+episode["season"]+'</h2>'
            end
            series_text = series_text + '<div class="no example"><h4 class="ui header">'+episode["episode"]+' - '+episode["title"]+'</h4><div class="ui message"><p>'+episode["description"]+'</p></div></div>'
        end  
        series_text = series_text + ((File.exists? $series_html_segment[3]) ? File.read($series_html_segment[3]) : '')   
        File.open(series_html, "w") { |file| file.write(series_text) }

    end
    master_text = master_text + ((File.exists? $master_html_segment[1]) ? File.read($master_html_segment[1]) : '')
    File.open($master_html, "w") { |file| file.write(master_text) }
end

def generate_resources

end

def generate_sitemap
end

$master_json = "../data/index.json"
$master_html = "../../index.html"
$master_html_segment = ["../segments/html/index/1.html","../segments/html/index/2.html"]
$series_html_segment = ["../segments/html/series/1.html","../segments/html/series/2.html","../segments/html/series/3.html","../segments/html/series/4.html"]

# assign_scraper()
generate_html()
# generate_resources()
# generate_sitemap()
