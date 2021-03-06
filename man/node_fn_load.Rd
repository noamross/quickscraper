% Generated by roxygen2 (4.0.1): do not edit by hand
\name{node_fn_load}
\alias{node_fn_load}
\title{Create a function to call a wrapped node.js package}
\usage{
node_fn_load(node_package, node_cmd = node_package, node_dir = "node",
  r_package = NULL, return_list = TRUE, ...)
}
\arguments{
\item{node_package}{the directory name of the node package}

\item{the}{'bin' command of the node package.  Defaults to the package name}

\item{node_dir}{the directory where node packages are kept.  Defaults to
'node', which should be a directory under 'inst' when
creaing your own package.}

\item{r_package}{the package name which wraps the function.  Defaults to the
\link{parent.frame}, assuming that \code{node_fn_load} is
being used in a package.}

\item{return_list}{If \code{TRUE}, the new function will return a list of
the return value, stdout, and stderr from the call to the
node.js function.  If \code{FALSE}, the new function will
return the results of a \link{system2} call.}

\item{...}{Additional parameters to pass to \link{system2} if
                   \code{return_list=TRUE}}
}
\description{
Create a function to call a wrapped node.js package
}

