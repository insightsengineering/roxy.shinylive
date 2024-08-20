test_that("examplesShinylive tag - errors - missing @examples", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #' @examplesShinylive
    f <- function(x, y) x + y
  "
  expect_snapshot(
    block <- roxygen2::parse_text(text)[[1]]
  )
  expect_false(roxygen2::block_has_tags(block, "examplesShinylive"))
})

test_that("examplesShinylive tag - single occurrence", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #' @examplesShinylive
    #' @examples
    #' f(1, 2)
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinylive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinylive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinylive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinylive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinylive tag - multiple occurrences", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @examplesShinylive
    #' @examples
    #' f(1, 2)
    #' @examplesShinylive
    #' @examples
    #' f(1, 3)
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinylive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinylive"),
    2
  )
  expect_identical(
    roxygen2::block_get_tags(block, "examplesShinylive")[[1]]$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tags(block, "examplesShinylive")[[2]]$raw,
    "\nf(1, 3)"
  )
  expect_identical(
    roxygen2::block_get_tags(block, "examplesShinylive")[[1]]$val,
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
  expect_identical(
    roxygen2::block_get_tags(block, "examplesShinylive")[[2]]$val,
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIBmASjAF8BdIA"
  )
})

test_that("examplesShinylive tag - don't use previous example code", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #'
    #' @examples
    #' x <- 'this is excluded'
    #' @examplesShinylive
    #' @examples
    #' f(1, 2)
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinylive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinylive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinylive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinylive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinylive tag - keywords - {{next_example}}", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #'
    #' @examplesShinylive
    #' {{ next_example }}
    #' @examples
    #' f(1, 2)
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinylive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinylive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinylive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinylive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinylive tag - keywords - {{prev_example}}", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #'
    #' @examples
    #' f(1, 2)
    #' @examplesShinylive
    #' {{ prev_example }}
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinylive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinylive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinylive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinylive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinylive tag - keywords - {{examples}}", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #'
    #' @examples
    #' f(1, 2)
    #' @examplesShinylive
    #' {{ examples[[1]] }}
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinylive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinylive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinylive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinylive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinylive tag - keywords - {{tags_examples}}", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #'
    #' @examples
    #' f(1, 2)
    #' @examplesShinylive
    #' {{ tags_examples[[1]]$raw }}
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinylive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinylive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinylive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinylive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinylive tag - keywords - error when parsing with glue", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #' @examplesShinylive
    #' {{ keyword_not_found }}
    f <- function(x, y) x + y
  "
  expect_snapshot(
    block <- roxygen2::parse_text(text)[[1]]
  )
  expect_false(roxygen2::block_has_tags(block, "examplesShinylive"))
})



test_that("examplesShinylive tag - decorate using {{next_example}} keyword", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #'
    #' @example
    #' x <- 'this is excluded'
    #' @examplesShinylive
    #' x1 <- 1 # this is included
    #' {{ next_example }}
    #' x2 <- 2 # this is included
    #' @examples
    #' f(1, 2)
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinylive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinylive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinylive")$raw,
    "x1 <- 1 # this is included\n\nf(1, 2)\nx2 <- 2 # this is included"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinylive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMADwEYACAHgFp6GBie0gCwEsBnegKEQCAGwCuAEzhSAOhAUAzABS1c9AEwBKBdU1NWBzj2FnRkmVLABfALpA" # nolint: line_length_linter.
  )
})
