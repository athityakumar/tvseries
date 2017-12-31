# TV Series


TV Series is a tool that scrapes Episode Synopsis' of popular TV Series' from websites like Wikipedia / IMDb and shows it all in one single place, with a better user-friendly navigation UI.

Website is accessible at https://athityakumar.github.io/tvseries/index.html


# List of contents

- [To-do](#to-do)
- [Supported TV Series](#supported-tv-series)
- [Working of the scripts](#working-of-the-scripts)
- [Resources](#resources)
- [Sitemap](#sitemap)
- [How to contribute](#how-to-contribute)
- [License](#license)



## To-do


[Back to contents](#list-of-contents)

- [x] Add UI Sample Templates
- [x] Generate SITEMAP markup file automatically with ruby script
- [x] Generate RESOURCES markup file automatically with ruby script
- [x] Add JSON files with proper structure
- [ ] Add scraping script (WIP)
- [x] Add HTML pages generator script
- [x] Add master shell-script that runs all scripts, and pushes changes into this repository
    - [x] Shell-script to deploy : [deploy.sh](https://github.com/athityakumar/tvseries/blob/master/deploy.sh)
    - [x] Ruby git program for smart auto-commit messages : [git.rb](https://github.com/athityakumar/tvseries/blob/master/git.rb.sh)
- [ ] Add a cron job for the master shell-script

## Supported TV Series'

[Back to contents](#list-of-contents)

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
- [x] Narcos
- [ ] Person of Interest
- [ ] Prisonbreak
- [ ] Suits
- [ ] Supergirl
- [ ] Supernatural
- [ ] The Big Bang Theory
- [x] The Flash
- [ ] The Walking Dead
- [ ] Vixen

Feel free to add more series' to the list by sending Pull Requests.


## Working of the scripts

[Back to contents](#list-of-contents)

The `auto/ruby/index.rb` and the `auto/data/index.json` files are the crucial players here. This is the step-by-step working of this repository :
(1) `auto/ruby/index.rb` reads the `auto/data/index.json` file and knows which website(s) to look up for which series.  

(2) `auto/ruby/index.rb` then visits these websites and scrapes required data from these websites.

(3) The scraped data is stored back into `auto/data/index.json` and other json files in `auto/data` directory.

(4) `auto/ruby/index.rb` again reads all these json files and creates respective html files, that result in the webpages you view.

(5) Simultaneously, `auto/ruby/index.rb` also automatically updates the `SITEMAP.md` and `RESOURCES.md` markup files.

Like the way it is automated? Star, fork and clone this repository. Contributions are always welcome.

## Resources
[Back to contents](#list-of-contents)


### Narcos
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/Narcos)
- [ ] [IMDb Link](http://www.imdb.com/title/tt2707408/)
- [ ] [Episode Synopsis Link](https://en.wikipedia.org/wiki/List_of_Narcos_episodes)


### The Flash
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/The_Flash_%282014_TV_series%29)
- [ ] [IMDb Link](http://www.imdb.com/title/tt3107288/)
- [ ] [Episode Synopsis Link](https://en.wikipedia.org/wiki/List_of_The_Flash_episodes)


### Person of Interest
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/Person_of_Interest_(TV_series))
- [ ] [IMDb Link](http://www.imdb.com/title/tt1839578/)
- [ ] [Episode Synopsis Link](https://en.wikipedia.org/wiki/List_of_Person_of_Interest_episodes)


### Gotham
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/Gotham_(TV_series))
- [ ] [IMDb Link](http://www.imdb.com/title/tt3749900/)
- [ ] [Episode Synopsis Link](https://en.wikipedia.org/wiki/List_of_Gotham_episodes)


### Game of Thrones
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/Game_of_Thrones)
- [ ] [IMDb Link](http://www.imdb.com/title/tt0944947/)
- [ ] [Episode Synopsis Link](https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_episodes)


### White Collar
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/White_Collar_(TV_series))
- [ ] [IMDb Link](http://www.imdb.com/title/tt1358522/)
- [ ] [Episode Synopsis Link](https://en.wikipedia.org/wiki/List_of_White_Collar_episodes)


### Breaking Bad
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/Breaking_Bad)
- [ ] [IMDb Link](http://www.imdb.com/title/tt0903747/)
- [ ] [Episode Synopsis Link](http://breakingbad.wikia.com/wiki/Pilot)


### DC's Legends of Tomorrow
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/Legends_of_Tomorrow)
- [ ] [IMDb Link](http://www.imdb.com/title/tt4532368/)
- [ ] [Episode Synopsis Link](https://en.wikipedia.org/wiki/Legends_of_Tomorrow)


### Sherlock
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/Sherlock_(TV_series))
- [ ] [IMDb Link](http://www.imdb.com/title/tt1475582/)
- [ ] [Episode Synopsis Link](https://en.wikipedia.org/wiki/List_of_Sherlock_episodes)


### Firefly
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/Firefly_(TV_series))
- [ ] [IMDb Link](http://www.imdb.com/title/tt0303461/?ref_=nv_sr_1)
- [ ] [Episode Synopsis Link](https://en.wikipedia.org/wiki/Firefly_(TV_series))


### Top of the Lake
- [ ] [Wikipedia Link](https://en.wikipedia.org/wiki/Top_of_the_Lake)
- [ ] [IMDb Link](http://www.imdb.com/title/tt2103085/?ref_=nv_sr_1)
- [ ] [Episode Synopsis Link](https://en.wikipedia.org/wiki/Top_of_the_Lake)


## Sitemap

[Back to contents](#list-of-contents)


```
auto/

      data/

            bb.json
            firefly.json
            flash.json
            got.json
            gotham.json
            index (copy).json
            index.json
            lot.json
            narcos.json
            poi.json
            sherlock.json
            totl.json
            whitecollar.json

      ruby/
            index.rb

      segments/

            html/

                  index.html.erb
                  series.html.erb

            md/
                  README.md.erb

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

            arrow.png
            bb.png
            firefly.png
            flash.png
            got.png
            gotham.png
            lot.png
            narcos.png
            poi.png
            sherlock.png
            tofl.png
            whitecollar.png

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
      firefly.html
      flash.html
      got.html
      gotham.html
      lot.html
      narcos.html
      poi.html
      sherlock.html
      totl.html
      whitecollar.html

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

.travis.yml
README.md
deploy.sh
git.rb
index.html
sample_homepage.html
sample_series.html

```

## How To Contribute

[Back to contents](#list-of-contents)


The work flow is the same as that of any other repository.
(1) Fork / clone the repository.
(2) Create a new branch , say `my-changes` and make your changes in this branch.
(3) Commit your changes and send a Pull request (PR) to this repository.
Active contributors would be rewarded with the tag of "Collabrators"
Bug fixes,Issues , Issue solutions , Optimizations , Enhancements are always welcome.



## License

[Back to contents](#list-of-contents)

The MIT License Copyright (c) 2017 - [Athitya Kumar](https://github.com/athityakumar).

Please have a look at the [LICENSE.md](LICENSE.md) for more details
