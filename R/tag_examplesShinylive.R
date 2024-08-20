#' Custom `examplesShinylive` tag.
#'
#' This function generates a new "Examples in Shinylive" section in the documentation. This section contains URL to
#' the application in Shinylive as well as an iframe with the application.
#' If no code is provided then the code is taken from the following `@examples` or `@examplesIf` tag.
#'
#' The application code must be executable inside Shinylive. If the application code includes functions from your
#' package, you must add `library(<your package>)` beforehand. For more information, refer to the Decoration section
#' on how to use and decorate existing examples.
#'
#' Note: All the packages used in the application code need to be installable in WebR.
#' See [this article](https://docs.r-wasm.org/webr/latest/packages.html) for more details.
#'
#' @section Decoration:
#'
#' To avoid repetition between the `@examplesShinylive` and `@examples` sections, there are special string literals
#' that provide access to the other tags from within the content of `@examplesShinylive`.
#' These literals should be used as expressions embraced with `{{ }}`, which are then interpolated using
#' `glue::glue_data(..., .open = "{{", .close = "}}")`.
#'
#' The following keywords are available:
#' * `"{{ tags_examples }}"` - a list of `@examples` or `@examplesIf` tags
#' * `"{{ examples }}"` - a list of "raw" elements from `tags_examples` list elements
#' * `"{{ next_example }}"` - "raw" element of the next example
#' * `"{{ prev_example }}"` - "raw" element of the previous example
#'
#' This allows you to access and decorate existing example code to create executable application code for Shinylive.
#' Refer to the examples section for possible use cases.
#'
#' @name tag-examplesShinylive
#'
#' @usage
#' #' @examplesShinylive${1:# example code (optional)}
#'
#' @examples
#' # As a part of documentation:
#'
#' # basic example:
#' #' (docs)
#' #' @examplesShinylive
#' #' @examples
#' #' (example code)
#'
#' # using keywords:
#' #' (docs)
#' #' @examplesShinylive
#' #' foo <- 1
#' #' {{ next_example }}
#' #' bar <- 2
#' #' @examples
#' #' (your example code)
#'
#' # A typical example would be:
#' #' (docs)
#' #' @examplesShinylive
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
#' #' @examplesShinylive
#' #' @examples
#' #' (your example app 1)
#' #' @examplesShinylive
#' #' @examples
#' #' (your example app 2)
#'
#' # skip parts of example code:
#' #' (docs)
#' #' @examples
#' #' (your example code - skipped)
#' #' @examplesShinylive
#' #' @examples
#' #' (your example code - included)
#'
#' # multiple apps with keywords:
#' #' (docs)
#' #' @examplesShinylive
#' #' x <- 1
#' #' {{ next_example }}
#' #' @examples
#' #' (your example app 1)
#' #' @examplesShinylive
#' #' y <- 1
#' #' {{ next_example }}
#' #' @examples
#' #' (your example app 2)
NULL

#' @noRd
#' @exportS3Method roxygen2::roxy_tag_parse roxy_tag_examplesShinylive
#' @importFrom glue glue_data
#' @importFrom stringr str_trim
#' @importFrom roxygen2 warn_roxy_tag
roxy_tag_parse.roxy_tag_examplesShinylive <- function(x) {
  if (stringr::str_trim(x$raw) == "") {
    x$raw <- "{{ next_example }}"
  }

  # not elegant but this is the most efficient way to access sibling tags
  tokens <- get("tokens", envir = parent.frame(3L))

  tags_examples <- Filter(function(x) x$tag %in% c("examples", "examplesIf"), tokens)

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
  x$val <- create_shinylive_url(x$raw) # nolint: object_usage_linter.
  x
}

#' @noRd
#' @exportS3Method roxygen2::roxy_tag_rd roxy_tag_examplesShinylive
#' @importFrom roxygen2 rd_section
roxy_tag_rd.roxy_tag_examplesShinylive <- function(x, base_path, env) {
  roxygen2::rd_section("examplesShinylive", x$val)
}

#' @noRd
#' @exportS3Method format rd_section_examplesShinylive
format.rd_section_examplesShinylive <- function(x, ...) {
  iframe_attrs <- paste(
    "height=\"800\"",
    "width=\"150\\%\"", # @TODO: find a better way to set the width
    "allow=\"fullscreen\"",
    "scrolling=\"auto\"",
    sep = " "
  )
  iframe_style <- paste(
    "border: 1px solid rgba(0,0,0,0.175);",
    "border-radius: .375rem;",
    sep = " "
  )
  iframe_style <- paste0("style=\"", iframe_style, "\"")
  paste0(
    "\\section{Examples in Shinylive}{\n",
    "\\itemize{\n",
    paste0(
      "  \\item example-", seq_along(x$value), "\\cr\n",
      "    \\href{", x$value, "}{Open in Shinylive}\\cr\n",
      "    \\if{html}{\\out{<iframe src=\"", x$value, "\" ", iframe_attrs, " ", iframe_style, "></iframe>}}\n",
      collapse = ""
    ),
    "}\n",
    "}\n"
  )
}
