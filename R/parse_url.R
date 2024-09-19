#' Creates Shinylive url based on app code.
#'
#' @importFrom jsonlite unbox toJSON
#' @importFrom lzstring compressToEncodedURIComponent
#'
#' @param code (`character(1)`) A string with app code.
#' @param mode (`character(1)`) A string with mode. One of "app" or "editor".
#' @param header (`logical(1)`) A logical value indicating whether to include header.
#' Ignored if `mode` is "editor".
#' @return (`character(1)`) Shinylive app url.
#'
#' @export
#'
#' @examples
#' code <- "this is your app code as a string"
#' create_shinylive_url(code)
create_shinylive_url <- function(code, mode = c("app", "editor"), header = TRUE) {
  stopifnot(is.character(code) && length(code) == 1)
  match.arg(mode)
  stopifnot(is.logical(header) && length(header) == 1)

  # implementation based on "Create ShinyLive Link" feature of Shiny VSCode extension
  # https://github.com/posit-dev/shiny-vscode/blob/80560bf36d516ff89dffe88bd9a28cee9edd4d43/src/shinylive.ts#L499
  files <- list(
    name = jsonlite::unbox("app.R"),
    content = jsonlite::unbox(code)
  )
  files_json <- jsonlite::toJSON(list(files))
  files_lz <- lzstring::compressToEncodedURIComponent(as.character(files_json))
  files_lz <- gsub("/", "-", files_lz)

  header_param <- ifelse(mode == "app" && isFALSE(header), "h=0&", "")

  sprintf("https://shinylive.io/r/%s/#%scode=%s", mode, header_param, files_lz)
}
