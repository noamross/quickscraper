#' @include node.R

#' @export
qs_cmd = node_fn_load("quickscrape")

#' @import stringi
get_package_scrapers = function() {
  scrapers_dir = system.file("journal-scrapers", "scrapers",
                             package="quickscraper")
  scraper_files = list.files(scrapers_dir, pattern="\\.json")
  scraper_names = stri_match_first_regex(scraper_files, '.+(?=\\.json)')
  scraper_files = file.path(scrapers_dir, scraper_files)
  names(scraper_files) = scraper_names
  return(scraper_files)
}

package_scrapers = get_package_scrapers()

#' Scrape data from web pages 
#' 
#' Take a vector of URLs and scrape data from the associated web pages, using
#' \code{quickscrape}
#' @param urls A vector of URLs to scrape
#' @param scraper A single scraper to use, or list of scrapers the same length
#' as \code{urls}.  If \code{NULL}, \code{scrape} will choose scrapers based on
#' the domains of URLs
#' @param list The form to return results in, either "list", "data.frame", or
#' "none" to only retain results as JSON files on disk
#' @param outdir  The directory to write results to.
#' @import plyr stringi
#' @export
scrape = function(urls, url_file=NULL, ratelimit=3, scraper="generic_open", 
                  args = list(), outdir=NULL, 
                  results=c("load", "save", "both"))) {
  results = match.arg(results)
  if(!(results %in% c("load", "save", "both"))) {
    stop("'results' must match 'load', 'save', or 'both")
  }
  
  if (!is.null(url_file)) {
      args = c(args, urllist = url_file)
  } else if (length(urls > 1)) {
      url_file = tempfile()
      cat(urls, sep="\n", file=url_file)
      args = c(args, urllist = url_file)
  } else {
      args = c(args, url=urls)
  }
  
  if(any(class(scraper) %in% c("list", "scraper"))) {
    filename = tempfile(fileext="json")
    cat(toJSON(scraper), file=filename)
    scraper_obj = scraper
    scraper = filename
  } else if(!file.exists(scraper) & (scraper %in% names(package_scrapers))) {
    scraper = package_scrapers[scraper]
    names(scraper) = NULL
    scraper_obj = fromJSON(scraper)
  } else if(file.exists(scraper)) {
    scraper_obj = fromJSON(scraper)
  } else {
    stop("Scraper not found")
  }
  
  args = c(args, scraper=scraper)
  
  if(is.null(outdir)) outdir=tempdir()
  args = c(args, output=outdir)
  
  run = qs_cmd(args)
  
  if(results=="save") return(run)  
  
  if(results %in% c("save", "both")) {
    out_dirs = list.files(outdir)
    output = alply(out_dirs, 1, function(z) {
      fromJSON(file.path(outdir, z, "results.json"), simplifyVector=FALSE)
    })
    attr(output, "split_type") = NULL
    attr(output, "split_labels") = NULL
    names(output) = out_dirs
  }
  
  if(results=="load") unlink(outdir, recursive=TRUE)
  if(results %in% c("load", "both")) return(output)  
}

