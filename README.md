# quickscraper

An R wrapper for the [quickscrape](https://github.com/ContentMine/quickscrape)
web scraping tool.

Note that this repository contains submodule for both 
[quickscrape](https://github.com/ContentMine/quickscrape) and
[journal-scrapers](https://github.com/ContentMine/journal-scrapers).  When
cloning:

```
git clone https://github.com/noamross/quickscraper
cd quickscraper
git submodule init
git submodule update
```

or `git clone --recursive https://github.com/noamross/quickscraper`

After you load the package, you must install the `quickscrape` dependencies.
To do this, run `node_pkg_build('quickscrape', 'quickscraper')