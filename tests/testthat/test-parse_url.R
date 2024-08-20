test_that("create_shinylive_url works as expected", {
  app_code <- "x <- 1"
  expect_identical(
    create_shinylive_url(app_code),
    "https://shinylive.io/r/app/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMADwAIAeAWloEYwBfAXSA"
  )
})
