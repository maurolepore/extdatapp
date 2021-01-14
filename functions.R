library(fs)
library(rlang)

# Paths to installed external data from packages
#
# Creates paths to R-package-files installed in your system.
#
# packages String (optional). The name of one or more packages. `NULL` defaults
#   to all packages in installed in your system.
# regexp String. A regular expression to pick paths matching it.
# ... Other arguments passed on to fs::dir_ls.
#
# examples
# extdata_path(regexp = "mtcars")
# extdata_path("vroom", "mtcars")
extdata_path <- function(packages = NULL, regexp = NULL, ...) {
  packages <- packages %||% rownames(installed.packages())

  files <- lapply(packages, extdata_path_one, regexp = regexp, ...)
  unname(unlist(files))
}

extdata_path_one <- function(package, regexp, ...) {
  dir <- tryCatch(
    system.file("extdata_path", package = package, mustWork = TRUE),
    error = function(e) character(0)
  )
  fs::dir_ls(dir, regexp = regexp, ...)
}


