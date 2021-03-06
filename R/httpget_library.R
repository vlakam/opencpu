httpget_library <- function(lib.loc, requri){
  #check if API has been enabled
  check.enabled("api.library");

  #set cache value
  res$setcache("lib");

  #extract the package name
  pkgname <- utils::head(requri, 1);
  if(!length(pkgname)){
    res$checkmethod();
    packages <- c()
    if (is.null(lib.loc)) {
        lib.loc <- .libPaths()
        packages <- loadedNamespaces()
    }

    packages <- c(packages, list.files(lib.loc))
    unique(packages)
    res$sendlist(packages)
  }

  #shorthand for pkg::object notation
  if(grepl("::", pkgname, fixed = TRUE)){
    parts <- strsplit(pkgname, "::", fixed = TRUE)[[1]]
    pkgname <- parts[1]
    requri <- c(parts[1], "R", parts[2], utils::tail(requri, -1))
  }

  #find the package is the specified library.
  pkgpath <- find.package(pkgname, lib.loc=lib.loc)
  httpget_package(pkgpath, utils::tail(requri, -1));
}
