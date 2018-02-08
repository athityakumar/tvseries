Firstly, thanks for contributing to the project. :smile:

Do you wish to

1. Add a series?
2. Enhance the code?
3. Solve bugs?

We heartily welcome you! :heart:

### Workflow

The `auto/ruby/index.rb` and the `auto/data/index.json` files are the crucial players here. This is the step-by-step working of this repository :
(1) `auto/ruby/index.rb` reads the `auto/data/index.json` file and knows which website(s) to look up for which series.  

(2) `auto/ruby/index.rb` then visits these websites and scrapes required data from these websites.

(3) The scraped data is stored back into `auto/data/index.json` and other json files in `auto/data` directory.

(4) `auto/ruby/index.rb` again reads all these json files and creates respective html files, that result in the webpages you view.

(5) Simultaneously, `auto/ruby/index.rb` also automatically updates the `SITEMAP.md` and `RESOURCES.md` markup files.

### Before contributing

- Please make sure the issue is unassigned or assigned **to you**.
- If no such issue exists, make a new one and get yourself assigned.


### Contributing

You can see the issues [here](https://github.com/athityakumar/tvseries/issues).
Now making a pull request is very easy! :pizza:

1. Fork or clone this repository
2. Create a new branch. You can name it as you like. 
3. Make your changes in the branch
4. Commit your changes and send a pull request

And you have contributed to this cool project! :tada: 
