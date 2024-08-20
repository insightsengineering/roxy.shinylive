test_that("examplesShinyLive tag - errors - missing @examples", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #' @examplesShinyLive
    f <- function(x, y) x + y
  "
  expect_snapshot(
    block <- roxygen2::parse_text(text)[[1]]
  )
  expect_false(roxygen2::block_has_tags(block, "examplesShinyLive"))
})

test_that("examplesShinyLive tag - single occurrence", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #' @examplesShinyLive
    #' @examples
    #' f(1, 2)
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinyLive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinyLive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinyLive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinyLive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinyLive tag - multiple occurrences", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @examplesShinyLive
    #' @examples
    #' f(1, 2)
    #' @examplesShinyLive
    #' @examples
    #' f(1, 3)
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinyLive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinyLive"),
    2
  )
  expect_identical(
    roxygen2::block_get_tags(block, "examplesShinyLive")[[1]]$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tags(block, "examplesShinyLive")[[2]]$raw,
    "\nf(1, 3)"
  )
  expect_identical(
    roxygen2::block_get_tags(block, "examplesShinyLive")[[1]]$val,
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
  expect_identical(
    roxygen2::block_get_tags(block, "examplesShinyLive")[[2]]$val,
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIBmASjAF8BdIA"
  )
})

test_that("examplesShinyLive tag - don't use previous example code", {
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
    #' @examplesShinyLive
    #' @examples
    #' f(1, 2)
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinyLive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinyLive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinyLive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinyLive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinyLive tag - keywords - {{next_example}}", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #'
    #' @examplesShinyLive
    #' {{ next_example }}
    #' @examples
    #' f(1, 2)
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinyLive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinyLive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinyLive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinyLive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinyLive tag - keywords - {{prev_example}}", {
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
    #' @examplesShinyLive
    #' {{ prev_example }}
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinyLive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinyLive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinyLive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinyLive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinyLive tag - keywords - {{examples}}", {
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
    #' @examplesShinyLive
    #' {{ examples[[1]] }}
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinyLive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinyLive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinyLive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinyLive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinyLive tag - keywords - {{tags_examples}}", {
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
    #' @examplesShinyLive
    #' {{ tags_examples[[1]]$raw }}
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinyLive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinyLive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinyLive")$raw,
    "\nf(1, 2)"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinyLive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgDMAKARlwAIAmASjAF8BdIA"
  )
})

test_that("examplesShinyLive tag - keywords - error when parsing with glue", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #' @examplesShinyLive
    #' {{ keyword_not_found }}
    f <- function(x, y) x + y
  "
  expect_snapshot(
    block <- roxygen2::parse_text(text)[[1]]
  )
  expect_false(roxygen2::block_has_tags(block, "examplesShinyLive"))
})



test_that("examplesShinyLive tag - decorate using {{next_example}} keyword", {
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
    #' @examplesShinyLive
    #' x1 <- 1 # this is included
    #' {{ next_example }}
    #' x2 <- 2 # this is included
    #' @examples
    #' f(1, 2)
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])
  expect_true(roxygen2::block_has_tags(block, "examplesShinyLive"))
  expect_length(
    roxygen2::block_get_tags(block, "examplesShinyLive"),
    1
  )
  expect_identical(
    roxygen2::block_get_tag(block, "examplesShinyLive")$raw,
    "x1 <- 1 # this is included\n\nf(1, 2)\nx2 <- 2 # this is included"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinyLive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMADwEYACAHgFp6GBie0gCwEsBnegKEQCAGwCuAEzhSAOhAUAzABS1c9AEwBKBdU1NWBzj2FnRkmVLABfALpA"
  )
})
