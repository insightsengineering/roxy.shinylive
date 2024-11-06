#' Custom `@examplesShinylive` tag.
#'
#' This function generates a new "Examples in Shinylive" section in the documentation.
#' This section contains URL to the application in Shinylive and for HTML outputs: an iframe with the application.
#' If no code is provided then the code is taken from the following `@examples` or `@examplesIf` tag.
#'
#' The application code must be executable inside Shinylive. If the application code includes functions from your
#' package, you must add `library(<package>)` beforehand. For more information, refer to the Decoration section
#' on how to use and decorate existing examples.
#'
#' Note: All the packages used in the application code need to be installable in WebR.
#' See [this article](https://docs.r-wasm.org/webr/latest/packages.html) for more details.
#'
#' @section Decoration:
#'
#' To avoid repetition between the `@examplesShinylive` and `@examples` sections contents,
#' there are special string literals to be used inside `@examplesShinylive` tag content
#' that allow you to access the content(s) of the `@examples` or `@examplesIf` tags.
#' These literals should be used as expressions embraced with `{{ }}`, which are then interpolated using
#' `glue::glue_data(..., .open = "{{", .close = "}}")`.
#'
#' The following keywords are available:
#' * `"{{ next_example }}"` - (the default if empty) "raw" element of the next example
#' * `"{{ prev_example }}"` - "raw" element of the previous example
#' * `"{{ tags_examples }}"` - a list of `@examples` or `@examplesIf` tags
#' * `"{{ examples }}"` - a list of "raw" elements from `tags_examples` list elements
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
#' # using keywords - `{{ next_example }}`:
#' #' (docs)
#' #' @examplesShinylive
#' #' foo <- 1
#' #' {{ next_example }}
#' #' bar <- 2
#' #' @examples
#' #' (example code)
#'
#' # using keywords - `{{ prev_example }}`:
#' #' (docs)
#' #' bar <- 2
#' #' @examples
#' #' (example code)
#' #' @examplesShinylive
#' #' foo <- 1
#' #' {{ prev_example }}
#'
#' # A typical example would be:
#' #' (docs)
#' #' @examplesShinylive
#' #' library(<package>)
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
#' #' (example app 1)
#' #' @examplesShinylive
#' #' @examples
#' #' (example app 2)
#'
#' # skip parts of example code:
#' #' (docs)
#' #' @examples
#' #' (example code - skipped)
#' #' @examplesShinylive
#' #' @examples
#' #' (example code - included)
#'
#' # multiple apps with keywords:
#' #' (docs)
#' #' @examplesShinylive
#' #' x <- 1
#' #' {{ next_example }}
#' #' @examples
#' #' (example app 1)
#' #' @examplesShinylive
#' #' y <- 1
#' #' {{ next_example }}
#' #' @examples
#' #' (example app 2)
#'
#' # combining multiple examples:
#' #' (docs)
#' #' @examples
#' #' (app pre-requisites)
#' #' @examples
#' #' (example app)
#' #' @examplesShinylive
#' #' {{ paste0(examples, collapse = ", ") }}
#'
#' # identical to the above example but with a different approach:
#' #' (docs)
#' #' @examples
#' #' (app pre-requisites)
#' #' @examples
#' #' (example app)
#' #' @examplesShinylive
#' #' {{ paste0(lapply(tags_examples, `[[`, "raw"), collapse = ", ") }}
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
  tokens <- dynGet("tokens")

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
  app_height <- "800px"
  app_max_width <- "1400px"
  iframe_style <- paste0(
    "style=\"",
    paste(
      paste0("height: ", app_height),
      "width: 100vw",
      paste0("max-width: ", app_max_width),
      "border: 1px solid rgba(0,0,0,0.175)",
      "border-radius: .375rem",
      "position: absolute",
      "left: 50\\%",
      "margin-top: 30px",
      "transform: translateX(-50\\%)",
      "z-index: 1",
      sep = "; "
    ),
    "\""
  )
  paste0(
    "\\section{Examples in Shinylive}{\n",
    "\\describe{\n",
    paste0(
      "  \\item{example-", seq_along(x$value), "}{\n",
      "    \\href{", x$value, "}{Open in Shinylive}\n",
      "    \\if{html}{\\out{<iframe class=\"iframe_shinylive\" src=\"", x$value, "\" ", iframe_style, "></iframe>}}\n", # nolint: line_length_linter.
      "    \\if{html}{\\out{<div style='height: ", app_height, "; display: block;'>&nbsp;</div>}}\n",
      "  }\n",
      collapse = ""
    ),
    "}\n",
    "}\n"
  )
}
