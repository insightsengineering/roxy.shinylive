test_that("examplesShinylive tag - errors - missing @examples", {
  skip_if_not(packageVersion("roxygen2") >= "7.3.0")
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

test_that("examplesShinylive tag - on default use only next example code", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #'
    #' @examples
    #' 'this is excluded'
    #' @examplesShinylive
    #' @examples
    #' 'this is included'
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
    "\n'this is included'"
  )
  expect_identical(
    roxygen2::block_get_tag_value(block, "examplesShinylive"),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAHQgHJSALASwGcACNziAgGwFcAJnEF0wAXwC6QA"
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
  skip_if_not(packageVersion("roxygen2") >= "7.3.0")
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



test_that("format returns Rd parsable to HTML", {
  testthat::skip_if_not_installed("pkgdown")

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

  topic <- roxygen2::roc_proc_text(roxygen2::rd_roclet(), text)[[1]]
  rd_code <- capture.output(topic$get_section("examplesShinylive"))
  suppressWarnings(expect_no_warning(html_code <- pkgdown::rd2html(rd_code), message = ".*unexpected END_OF_INPUT.*"))
  expect_gt(length(html_code), 0)
})

test_that("format returns Rd parsable to tidy HTML", {
  testthat::skip_if_not_installed("pkgdown")
  testthat::skip_if_not_installed("withr")
  testthat::skip_if_not(
    nzchar(Sys.which("tidy")),
    "tidy is not installed"
  )

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

  topic <- roxygen2::roc_proc_text(roxygen2::rd_roclet(), text)[[1]]
  rd_code <- capture.output(topic$get_section("examplesShinylive"))
  html_code <- paste0(suppressWarnings(pkgdown::rd2html(rd_code)), collapse = "\n")
  withr::with_tempfile("x", {
    writeLines(html_code, x)
    # https://github.com/wch/r-source/blob/7450caaef0076c8b43dfdcc0deab1dbe646b8fc4/src/library/tools/R/htmltools.R#L19
    tidy_res <- suppressWarnings(system2(
      "tidy",
      c("-language en", "-qe", x),
      stdout = TRUE, stderr = TRUE
    ))
    tidy_res <- grep("line 1 column 1", tidy_res, value = TRUE, invert = TRUE)
    testthat::expect_setequal(tidy_res, character(0))
  })
})

test_that("examplesShinylive tag - respect order of tags - before examples", {
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

  block_tag_names <- vapply(block$tags, `[[`, character(1), "tag")

  expect_lt(
    which(block_tag_names == "examplesShinylive"),
    which(block_tag_names == "examples")
  )
})

test_that("examplesShinylive tag - respect order of tags - after examples", {
  text <- "
    #' This is a title
    #'
    #' This is the description.
    #'
    #' @param x,y A number
    #' @export
    #' @examples
    #' f(1, 2)
    #' @examplesShinylive
    #' {{ prev_example }}
    f <- function(x, y) x + y
  "
  expect_silent(block <- roxygen2::parse_text(text)[[1]])

  block_tag_names <- vapply(block$tags, `[[`, character(1), "tag")

  expect_gt(
    which(block_tag_names == "examplesShinylive"),
    which(block_tag_names == "examples")
  )
})
