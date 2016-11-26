TV SERIES
---------
TV Series is a tool that scrapes Episode Synopsis' of popular TV Series' from websites like Wikipedia / IMDb and show in one place with a user-friendly navigation UI.
<br>Website is accessible at https://athityakumar.github.io/tvseries/index.html 

TO-DO LIST
----------
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

LIST OF TV SERIES' SUPPORTED 
----------------------------
- [ ] Arrow
- [x] Breaking Bad
- [ ] Castle
- [ ] DC's Legends of Tomorrow
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

SITEMAP
-------
Have a look at the auto-generated [SITEMAP.md] (https://github.com/athityakumar/tvseries/blob/master/SITEMAP.md) file.

RESOURCES OF TV SERIES'
-----------------------
Have a look at the auto-generated [RESOURCES.md] (https://github.com/athityakumar/tvseries/blob/master/RESOURCES.md) file.

HOW THIS STUFF WORKS
--------------------
The `auto/ruby/index.rb` and the `auto/data/index.json` files are the crucial players here. This is the step-by-step working of this repository :
<br> (1) `auto/ruby/index.rb` reads the `auto/data/index.json` file and knows which website(s) to look up for which series.  
<br> (2) `auto/ruby/index.rb` then visits these websites and scrapes required data from these websites.
<br> (3) The scraped data is stored back into `auto/data/index.json` and other json files in `auto/data` directory.
<br> (4) `auto/ruby/index.rb` again reads all these json files and creates respective html files, that result in the webpages you view.
<br> (5) Simultaneously, `auto/ruby/index.rb` also automatically updates the `SITEMAP.md` and `RESOURCES.md` markup files.
<br><br> Like the way it is automated? Star, fork and clone this repository. Contributions are always welcome.

CONTRIBUTION
------------
The work flow is the same as that of any other repository. 
<br> (1) Fork / clone the repository.
<br> (2) Create a new branch , say `my-changes` and make your changes in this branch.
<br> (3) Commit your changes and send a Pull request (PR) to this repository.
<br> Active contributors would be rewarded with the tag of "Collabrators"
<br> Bug fixes , Issues , Issue solutions , Optimizations & Enhancements are always welcome.

LICENSE
-------
[The MIT License](https://github.com/athityakumar/tvseries/blob/master/LICENSE.md) - [Athitya Kumar](http://github.com/athityakumar) 
