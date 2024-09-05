# roxy.shinylive

## Overview

This package provides a `roxygen2` extension that automatically takes the code from the `@examples` tag that follows and crate an URL to the shinylive service. During the documentation build, a new section is added to the function manual that contains aforementioned link as well as iframe to the application itself.

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
\section{Examples in Shinylive}{
\describe{
  \item{example-1}{
    \href{https://shinylive.io/r/app/#code=...}{Open in Shinylive}
    \if{html}{\out{<script type="text/javascript">(custom JS)</script>}}
    \if{html}{\out{<iframe src="https://shinylive.io/r/app/#code=..."></iframe>}}
  }
  \item{example-2}{
    \href{https://shinylive.io/r/app/#code=...}{Open in Shinylive}
    \if{html}{\out{<script type="text/javascript">(custom JS)</script>}}
    \if{html}{\out{<iframe src="https://shinylive.io/r/app/#code=..."></iframe>}}
  }
  ...
}
}
```

See the package documentation for more details.
