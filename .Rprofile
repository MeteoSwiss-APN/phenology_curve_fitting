source("renv/activate.R")

Sys.setenv(TERM_PROGRAM = "vscode")
Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1)

source(file.path(
  Sys.getenv(
    if (.Platform$OS.type == "windows") {
      "USERPROFILE"
    } else {
      "HOME"
    }
  ),
  ".vscode-R", "init.R"
))

options(vsc.plot = "Two")
options(vsc.dev.args = list(width = 800, height = 600))
options(vsc.browser = "Two")
options(vsc.viewer = "Two")
options(vsc.page_viewer = "Two")
options(vsc.view = "Two")

options(error = function() {
  calls <- sys.calls()
  if (length(calls) >= 2L) {
    sink(stderr())
    on.exit(sink(NULL))
    cat("Backtrace:\n")
    calls <- rev(calls[-length(calls)])
    for (i in seq_along(calls)) {
      cat(i, ": ", deparse(calls[[i]], nlines = 1L), "\n", sep = "")
    }
  }
  if (!interactive()) {
    q(status = 1)
  }
})
