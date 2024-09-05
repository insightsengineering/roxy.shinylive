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
\itemize{
\item example-1 \cr
\href{https://shinylive.io/r/app/#code=...}{Open in Shinylive}\cr
\if{html}{\out{ ... (HTML code including <iframe> to Shinylive) }}\cr
}
\item{example-2}{\cr
\href{https://shinylive.io/r/app/#code=...}{Open in Shinylive}\cr
\if{html}{\out{ ... (HTML code including <iframe> to Shinylive) }}\cr
}
...
}
}
```

See the package documentation for more details.
