# examplesShinylive tag - errors - missing @examples

    Code
      block <- roxygen2::parse_text(text)[[1]]
    Message
      x <text>:8: @examplesShinylive requires a value.

# examplesShinylive tag - keywords - error when parsing with glue

    Code
      block <- roxygen2::parse_text(text)[[1]]
    Message
      x <text>:8: @examplesShinylive failed to interpolate the content.

