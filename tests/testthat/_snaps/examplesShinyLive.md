# examplesShinyLive tag - errors - missing @examples

    Code
      block <- roxygen2::parse_text(text)[[1]]
    Message
      x <text>:8: @examplesShinyLive requires a value.

# examplesShinyLive tag - keywords - error when parsing with glue

    Code
      block <- roxygen2::parse_text(text)[[1]]
    Message
      x <text>:8: @examplesShinyLive failed to interpolate the content.

