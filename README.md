# roxy.shinylive

## Overview

This package provides a `roxygen2` extension that automatically takes the example code from `@examples` tag that follows and crate an URL to the shinylive service. That URL is then added to the documentation.

## Install

```r
pak::pak("insightsengineering/roxy.shinylive")
```

## Usage

In your `DESCRIPTION` file, add the following:
```yaml
Roxygen: list(markdown = TRUE, packages = c("roxy.shinylive"))
```

Then in your package documentation:
```r
#' (docs)
#' @examplesShinylive
#' @examples
#' (example code with a Shiny app)
```

Which would produce a following output in your documentation:

```Rd
\section{Run examples in Shinylive}{
\itemize{
  \item\href{https://shinylive.io/r/app/#code=...}{example-1}
  \item\href{https://shinylive.io/r/app/#code=...}{example-2}
  ...
}
}
```

See the package documentation for more details.
