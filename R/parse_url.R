#' Creates Shinylive url for the app code.
#'
#' @importFrom jsonlite unbox toJSON
#' @importFrom lzstring compressToEncodedURIComponent
#'
#' @param code (`character(1)`) A string with app code.
#' @return (`character(1)`) Shinylive app url.
#'
#' @export
#'
#' @examples
#' code <- "this is your app code as a string"
#' create_shinylive_url(code)
create_shinylive_url <- function(code) {
  stopifnot(is.character(code) && length(code) == 1)

  # implementation based on "Create ShinyLive Link" feature of Shiny VSCode extension
  # https://github.com/posit-dev/shiny-vscode/blob/80560bf36d516ff89dffe88bd9a28cee9edd4d43/src/shinylive.ts#L499
  files <- list(
    name = jsonlite::unbox("app.R"),
    content = jsonlite::unbox(code)
  )
  files_json <- jsonlite::toJSON(list(files))
  files_lz <- lzstring::compressToEncodedURIComponent(as.character(files_json))
  files_lz <- gsub("/", "-", files_lz)
  sprintf("https://shinylive.io/r/app/#code=%s", files_lz)
}
