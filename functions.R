# Paths to installed files from packages
#
# Creates paths to R-package-files installed in your system.
#
# packages String (optional). The name of one or more packages. `NULL` defaults
#   to all packages in installed in your system.
# regexp String. A regular expression to pick paths matching it.
# ... Other arguments passed on to fs::dir_ls.
#
# examples
# installed_files()
# installed_files(regexp = "dataset")
# installed_files("vroom", "dataset")
installed_files <- function(packages = NULL, regexp = NULL, ...) {
  all <- rownames(utils::installed.packages())
  packages <- packages %||% all

  files <- lapply(packages, installed_file, regexp = regexp, ...)
  unname(unlist(files))
}

installed_file <- function(package, regexp, ...) {
  dir <- tryCatch(
    system.file("extdata", package = package, mustWork = TRUE),
    error = function(e) character(0)
  )

  fs::dir_ls(dir, regexp = regexp, ...)
}

#' Help read data in different formats with the same interface
#'
#' @param path
#'
#' @examples
#' dataset <- BOD
#' dataset
#'
#' path <- fs::path(tempdir(), "dataset.csv")
#' readr::write_csv(dataset, path)
#' head(read_data(path))
#'
#' path <- fs::path(tempdir(), "dataset.rds")
#' readr::write_rds(dataset, path)
#' head(read_data(path))
#' @noRd
read_data <- function(path) {
  extension <- fs::path_ext(path)
  data <- switch(extension,
    "csv" = readr::read_csv(path),
    "tsv" = readr::read_tsv(path),
    "rds" = readr::read_rds(path),
    stop("Can't read files with extension: ", extension, call. = FALSE)
  )

  data
}

supported_extensions <- function() {
  format_regex(extensions())
}

extensions <- function() c("csv", "tsv", "rds")

format_regex <- function(extension) {
  format1_regex <- function(extension) paste0("[.]", extension, "$")
  out <- unname(vapply(extension, format1_regex, character(1)))
  out <- paste(out, collapse = "|")
  out
}

find_path <- function(x, path) {
  grep(x, path, value = TRUE)
}

find_package <- function(x) {
  fs::path_file(sub("extdata.*$", "", x))
}

find_dataset <- function(input, paths) {
  path <- find_path(input, paths)
  out <- read_data(path)
  out <- list(utils::head(out))
  out <- stats::setNames(out, find_package(path))
  out
}

files <- function(paths) {
  sort(fs::path_file(paths))
}

format_label <- function(x) {
  ext <- paste(extensions(), collapse = ", ")
  paste0(x, " (", ext, ")")
}

`%||%` <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}
