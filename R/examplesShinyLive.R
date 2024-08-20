#' Custom `examplesShinyLive` tag.
#'
#' This function generates a new section with ShinyLive links to the applications from this tag content.
#' If no code is provided then the code from the following `@examples` tag is used.
#'
#' The application code must be executable inside ShinyLive. If the application code includes functions from your
#' package, you must add `library(<your package>)` beforehand. For more information, refer to the Decoration section
#' on how to use and decorate existing examples.
#'
#' Note: All the packages used in the application code need to be installable in WebR.
#' See [this article](https://docs.r-wasm.org/webr/latest/packages.html) for more details.
#'
#' @section Decoration:
#'
#' To avoid repetition between the `@examplesShinyLive` and `@examples` sections, there are special string literals
#' that provide access to the `@examples` content from within `@examplesShinyLive`.
#' These literals should be used as expressions embraced with `{{ }}`, which are then interpolated using
#' `glue::glue_data(..., .open = "{{", .close = "}}")`.
#'
#' The following keywords are available:
#' * `"{{ tags_examples }}"` - a list of tags with examples
#' * `"{{ examples }}"` - a list of "raw" elements from `tags_examples`
#' * `"{{ next_example }}"` - "raw" element of the next example
#' * `"{{ prev_example }}"` - "raw" element of the previous example
#'
#' This allows you to access and decorate existing example code to create executable application code for ShinyLive.
#' Refer to the examples section for possible use cases.
#'
#' @name tag-examplesShinyLive
#'
#' @usage
#' #' @examplesShinyLive${1:# example code (optional)}
#'
#' @examples
#' # As a part of documentation:
#'
#' # basic example:
#' #' (docs)
#' #' @examplesShinyLive
#' #' @examples
#' #' (example code)
#'
#' # using keywords:
#' #' (docs)
#' #' @examplesShinyLive
#' #' foo <- 1
#' #' {{ next_example }}
#' #' bar <- 2
#' #' @examples
#' #' (your example code)
#'
#' # A typical example would be:
#' #' (docs)
#' #' @examplesShinyLive
#' #' library(<your package>)
#' #' interactive <- function() TRUE
#' #' {{ next_example }}
#' #' @examples
#' #' app <- ...
#' #' if (interactive()) {
#' #'   shinyApp(app$ui, app$server)
#' #' }
#'
#' # multiple apps:
#' #' (docs)
#' #' @examplesShinyLive
#' #' @examples
#' #' (your example app 1)
#' #' @examplesShinyLive
#' #' @examples
#' #' (your example app 2)
#'
#' # skip parts of example code:
#' #' (docs)
#' #' @examples
#' #' (your example code - skipped)
#' #' @examplesShinyLive
#' #' @examples
#' #' (your example code - included)
#'
#' # multiple apps with keywords:
#' #' (docs)
#' #' @examplesShinyLive
#' #' x <- 1
#' #' {{ next_example }}
#' #' @examples
#' #' (your example app 1)
#' #' @examplesShinyLive
#' #' y <- 1
#' #' {{ next_example }}
#' #' @examples
#' #' (your example app 2)
NULL

#' @noRd
#' @exportS3Method roxygen2::roxy_tag_parse roxy_tag_examplesShinyLive
#' @importFrom glue glue_data
#' @importFrom stringr str_trim
#' @importFrom roxygen2 warn_roxy_tag
roxy_tag_parse.roxy_tag_examplesShinyLive <- function(x) {
  if (stringr::str_trim(x$raw) == "") {
    x$raw <- "{{ next_example }}"
  }

  # not elegant but this is the most efficient way to access sibling tags
  tokens <- get("tokens", envir = parent.frame(3L))

  tags_examples <- Filter(function(x) x$tag == "examples", tokens)

  examples <- lapply(tags_examples, `[[`, "raw")

  next_example <- Reduce(
    function(x, y) `if`(x$line < y$line, x, y),
    Filter(function(y) y$line > x$line, tags_examples)
  )$raw

  prev_example <- Reduce(
    function(x, y) `if`(x$line > y$line, x, y),
    Filter(function(y) y$line < x$line, tags_examples)
  )$raw

  x$raw <- try(
    as.character(
      glue::glue_data(
        .x = list(
          tags_examples = tags_examples,
          examples = examples,
          next_example = next_example,
          prev_example = prev_example
        ),
        x$raw,
        .open = "{{",
        .close = "}}"
      )
    ),
    silent = TRUE
  )

  if (inherits(x$raw, "try-error")) {
    roxygen2::warn_roxy_tag(x, "failed to interpolate the content")
    return(NULL)
  }

  if (is.null(x$raw) || length(x$raw) == 0) {
    roxygen2::warn_roxy_tag(x, "requires a value")
    return(NULL)
  }
  x$val <- create_shinylive_url(x$raw)
  x
}

#' @noRd
#' @exportS3Method roxygen2::roxy_tag_rd roxy_tag_examplesShinyLive
#' @importFrom roxygen2 rd_section
roxy_tag_rd.roxy_tag_examplesShinyLive <- function(x, base_path, env) {
  roxygen2::rd_section("examplesShinyLive", x$val)
}

#' @noRd
#' @exportS3Method format rd_section_examplesShinyLive
format.rd_section_examplesShinyLive <- function(x, ...) {
  paste0(
    "\\section{Run examples in Shinylive}{\n",
    "\\itemize{\n",
    paste0("  \\item", "\\href{", x$value, "}{example-", seq_along(x$value), "}\n", collapse = ""),
    "}\n",
    "}\n"
  )
}
