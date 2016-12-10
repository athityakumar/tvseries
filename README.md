<h1> <u> TV SERIES </u> </h1>

TV Series is a tool that scrapes Episode Synopsis' of popular TV Series' from websites like Wikipedia / IMDb and shows it all in one single place, with a better user-friendly navigation UI. 
    
Website is accessible at https://athityakumar.github.io/tvseries/index.html

<div id = "top"> <br>
<h1> <u> LIST OF CONTENTS </u> </h1>
<ul> 
<li> <a href = "#todo"> To-do </a> </li>
<li> <a href = "#supported"> Supported TV Series' </a> </li>
<li> <a href = "#working"> Working of the scripts </a> </li>
<li> <a href = "#resources"> Resources </a> </li>
<li> <a href = "#sitemap"> Sitemap </a> </li>
<li> <a href = "#contribute"> How to contribute </a> </li>
<li> <a href = "#license"> License </a> </li>
</ul>
</div>

<div id = "todo"> <br> </div>
<h1> <u> To-do </u> </h1>
<i><a href = "#top"> Back to contents </a></i>
<br><br>
- [x] Add UI Sample Templates
- [x] Generate SITEMAP markup file automatically with ruby script
- [x] Generate RESOURCES markup file automatically with ruby script
- [x] Add JSON files with proper structure
- [ ] Add scraping script (WIP)
- [x] Add HTML pages generator script
- [x] Add master shell-script that runs all scripts, and pushes changes into this repository
    - [x] Shell-script to deploy : [deploy.sh] (https://github.com/athityakumar/tvseries/blob/master/deploy.sh)
    - [x] Ruby git program for smart auto-commit messages : [git.rb] (https://github.com/athityakumar/tvseries/blob/master/git.rb.sh)
- [ ] Add a cron job for the master shell-script

<div id = "supported"> <br> </div>
<h1> <u> Supported TV Series' </u> </h1>
<i><a href = "#top"> Back to contents </a></i>
<br><br>

- [ ] Arrow
- [x] Breaking Bad
- [ ] Castle
- [x] DC's Legends of Tomorrow
- [ ] Friends
- [x] Game of Thrones
- [ ] Gotham
- [ ] How I Met your Mother
- [ ] Marvel's Agents of S.H.I.E.L.D
- [ ] Modern Family
- [ ] Narcos
- [ ] Person of Interest
- [ ] Prisonbreak
- [ ] Suits
- [ ] Supergirl
- [ ] Supernatural
- [ ] The Big Bang Theory
- [x] The Flash
- [ ] The Walking Dead
- [ ] Vixen

<br>Feel free to add more series' to the list by sending Pull Requests.

<div id = "working"> <br> </div>
<h1> <u> Working of the scripts </u> </h1>
<i><a href = "#top"> Back to contents </a></i>
<br><br>
The `auto/ruby/index.rb` and the `auto/data/index.json` files are the crucial players here. This is the step-by-step working of this repository :
<br> (1) `auto/ruby/index.rb` reads the `auto/data/index.json` file and knows which website(s) to look up for which series.  
<br> (2) `auto/ruby/index.rb` then visits these websites and scrapes required data from these websites.
<br> (3) The scraped data is stored back into `auto/data/index.json` and other json files in `auto/data` directory.
<br> (4) `auto/ruby/index.rb` again reads all these json files and creates respective html files, that result in the webpages you view.
<br> (5) Simultaneously, `auto/ruby/index.rb` also automatically updates the `SITEMAP.md` and `RESOURCES.md` markup files.
<br><br> Like the way it is automated? Star, fork and clone this repository. Contributions are always welcome.

<div id = "resources"> <br> </div>
<h1> <u> Resources </u> </h1>
<i><a href = "#top"> Back to contents </a></i>
<br><br>

 
###The Flash 
- [ ] [Wikipedia Link] (https://en.wikipedia.org/wiki/The_Flash_%282014_TV_series%29)
- [ ] [IMDb Link] (http://www.imdb.com/title/tt3107288/)
- [ ] [Episode Synopsis Link] (https://en.wikipedia.org/wiki/List_of_The_Flash_episodes)

 
###Gotham 
- [ ] [Wikipedia Link] (https://en.wikipedia.org/wiki/Gotham_(TV_series))
- [ ] [IMDb Link] (http://www.imdb.com/title/tt3749900/)
- [ ] [Episode Synopsis Link] (https://en.wikipedia.org/wiki/List_of_Gotham_episodes)

 
###Game of Thrones 
- [ ] [Wikipedia Link] (https://en.wikipedia.org/wiki/Game_of_Thrones)
- [ ] [IMDb Link] (http://www.imdb.com/title/tt0944947/)
- [ ] [Episode Synopsis Link] (https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_episodes)

 
###Breaking Bad 
- [ ] [Wikipedia Link] (https://en.wikipedia.org/wiki/Breaking_Bad)
- [ ] [IMDb Link] (http://www.imdb.com/title/tt0903747/)
- [ ] [Episode Synopsis Link] (http://breakingbad.wikia.com/wiki/Pilot)

 
###DC's Legends of Tomorrow 
- [ ] [Wikipedia Link] (https://en.wikipedia.org/wiki/Legends_of_Tomorrow)
- [ ] [IMDb Link] (http://www.imdb.com/title/tt4532368/)
- [ ] [Episode Synopsis Link] (https://en.wikipedia.org/wiki/Legends_of_Tomorrow)

 
###Sherlock 
- [ ] [Wikipedia Link] (https://en.wikipedia.org/wiki/Sherlock_(TV_series))
- [ ] [IMDb Link] (http://www.imdb.com/title/tt1475582/)
- [ ] [Episode Synopsis Link] (https://en.wikipedia.org/wiki/List_of_Sherlock_episodes)
    

<div id = "sitemap"> <br> </div>
<h1> <u> Sitemap </u> </h1>
<i><a href = "#top"> Back to contents </a></i>
<br><br>
<pre>


auto/

      data/

            bb.json
            flash.json
            got.json
            gotham.json
            index (copy).json
            index.json
            lot.json
            sherlock.json

      ruby/
            index.rb

      segments/

            html/

                  index.html.erb
                  series.html.erb

            md/
                  README.md.erb

      .DS_Store

dist/

      components/

            button.css
            card.css
            container.css
            dimmer.css
            dimmer.js
            divider.css
            dropdown.css
            dropdown.js
            form.css
            form.js
            grid.css
            header.css
            icon.css
            image.css
            input.css
            label.css
            list.css
            menu.css
            message.css
            popup.css
            popup.js
            rating.css
            rating.js
            reset.css
            reveal.css
            segment.css
            sidebar.css
            sidebar.js
            site.css
            table.css
            transition.css
            transition.js
            visibility.js

      themes/

            default/

                  assets/

                        fonts/

                              icons.eot
                              icons.eot?
                              icons.svg
                              icons.ttf
                              icons.woff
                              icons.woff2

                        images/
                              flags.png

      semantic.css
      semantic.js
      semantic.min.css
      semantic.min.js

images/

      series/

            .DS_Store
            arrow.png
            bb.png
            flash.png
            got.png
            gotham.png
            lot.png
            sherlock.png

      .DS_Store
      logo.png

javascript/

      library/

            clipboard.min.js
            cookie.min.js
            easing.min.js
            highlight.min.js
            history.min.js
            jquery.min.js
            less.min.js
            serialize-object.js
            sinon.js
            tablesort.js
            tablesort.min.js

      accordion.js
      api.js
      button.js
      card.js
      checkbox.js
      container.js
      dimmer.js
      docs.js
      dropdown.js
      embed.js
      form.js
      grid.js
      header.js
      home.js
      icon.js
      input.js
      item.js
      menu.js
      message.js
      modal.js
      new.js
      popup.js
      progress.js
      rating.js
      search.js
      shape.js
      sidebar.js
      started.js
      sticky.js
      tab.js
      table.js
      theming.js
      transition.js
      validate-form.js
      visibility.js

series/

      bb.html
      flash.html
      got.html
      gotham.html
      lot.html
      sherlock.html

src/

      definitions/

            collections/

                  breadcrumb.less
                  form.less
                  grid.less
                  menu.less
                  message.less
                  table.less

            elements/

                  button.less
                  container.less
                  divider.less
                  flag.less
                  header.less
                  input.less
                  label.less
                  list.less
                  loader.less
                  rail.less
                  segment.less
                  step.less

            globals/

                  reset.less
                  site.less

            modules/

                  accordion.less
                  checkbox.less
                  dimmer.less
                  dropdown.less
                  modal.less
                  popup.less
                  progress.less
                  rating.less
                  search.less
                  shape.less
                  sidebar.less

            views/

                  card.less
                  comment.less
                  feed.less
                  item.less
                  statistic.less

stylesheets/

      docs.css
      home.css
      rtl.css
      shape.css

.DS_Store
README.md
deploy.sh
git.rb
index.html
sample_homepage.html
sample_series.html
</pre>
    
<div id = "contribute"> <br> </div>
<h1> <u> How to contribute </u> </h1>
<i><a href = "#top"> Back to contents </a></i>
<br><br>
The work flow is the same as that of any other repository. 
<br> (1) Fork / clone the repository.
<br> (2) Create a new branch , say `my-changes` and make your changes in this branch.
<br> (3) Commit your changes and send a Pull request (PR) to this repository.
<br> Active contributors would be rewarded with the tag of "Collabrators"
<br> Bug fixes , Issues , Issue solutions , Optimizations & Enhancements are always welcome.

<div id = "license"> <br> </div>
<h1> <u> License </u> </h1>
<i><a href = "#top"> Back to contents </a></i>
<br><br>
The MIT License (MIT)

Copyright (c) 2016 Athitya Kumar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
    
