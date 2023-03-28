crug_skeleton <- function(path, ...) {
    # ensure path exists
    dir.create(path, recursive = TRUE, showWarnings = FALSE)

    dev_dir <- fs::path(path, "dev")
    dir.create(dev_dir, recursive = TRUE, showWarnings = FALSE)

    file.copy(
        from = system.file("dev", "01_dev.R", package = "crugdemo2", mustWork = TRUE),
        to = dev_dir,
        recursive = TRUE
    )

    dots <- list(...)

    if (dots$quarto_site) {
        quarto_site <- list.files(
            system.file("quarto_site", package = "crugdemo2", mustWork = TRUE),
            full.names = TRUE,
            include.dirs = TRUE,
            recursive = FALSE
        )

        docs_dir <- fs::path(path, "docs")

        dir.create(docs_dir, recursive = TRUE, showWarnings = FALSE)

        file.copy(
            from = quarto_site,
            to = docs_dir,
            overwrite = TRUE,
            recursive = TRUE
        )
    }

    if (dots$with_git) {
        cli::cat_rule("Initializing git repository")
        git_output <- system(
            command = paste("git init", path),
            ignore.stdout = TRUE,
            ignore.stderr = TRUE
        )
        if (git_output) {
            cli::cat_rule("Error initializing git epository")
        } else {
            cli::cat_rule("Initialized git repository")
        }
    }

    if (dots$python_venv) {
        python_venv_dir <- fs::path(path, "pyenv")
        reticulate::virtualenv_create(python_venv_dir)
    }

    if (dots$with_renv) renv::init(path)
}
