
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Monkeypox Clinical Diagnosis Analysis

[![License (for code):
MIT](https://img.shields.io/badge/License%20(for%20code)-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![License:
CC0-1.0](https://img.shields.io/badge/License%20(for%20data)-CC0_1.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

This repository contains data and R code which are supplements to

*Enhanced surveillance of monkeypox in Bas-Uélé, Democratic Republic of
Congo: the limitations of symptom-based case definitions*, by Gaspard
Mande, Innocent Akonda, Anja De Weggheleire, Isabel Brosius, Laurens
Liesenborghs, Emmanuel Bottieau, Noam Ross, Guy -Crispin Gembue, Robert
Colebunders, Erik Verheyen Ngonda Daulya, Herwig Leirsh, and Anne
Laudisoit (2022)

Please cite that paper, and/or the Zenodo data reference
(<https://dx.doi.org/10.5281/zenodo.6574451>) when using or refering to
this study.

## Repository Structure and Reproducibility

-   `data/` contains de-identified data from the study and a data
    dictionary
-   `R/` contains functions used in this analysis.
-   `reports/` contains literate code foor R Markdown reports generated
    in the analysis
-   `outputs/` contains compiled reports and figures.
-   This project uses the
    [{targets}](https://wlandau.github.io/targets-manual/) framework to
    organize build steps for analysis pipeline. The steps are defined in
    the `_targets.R` file and the workflow can be executed by running
    `run.R` via `source("run.R")` in your R terminal or `Rscript run.R`
    in your system shell.

``` mermaid
graph LR
  subgraph Legend
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- x5b3426b4c7fa7dbc([""Started""]):::started
    x5b3426b4c7fa7dbc([""Started""]):::started --- xbf4603d6c2c2ad6b([""Stem""]):::none
  end
  subgraph Graph
    x608f26fc87c17c04(["bas_corrplot"]):::uptodate --> xea144c390a1e3213(["corrplot_file"]):::uptodate
    xe22e80ea1c77ed8b(["bas_train_prepped"]):::uptodate --> x12e75493b9005333(["bas_validate_prepped"]):::uptodate
    xc9200d108e1b2a66(["bas_validate"]):::uptodate --> x12e75493b9005333(["bas_validate_prepped"]):::uptodate
    x2a8bb2bae1240fcd(["bas_excel"]):::uptodate --> x4b217d550d08ada0(["bas_data"]):::uptodate
    x3e4c5a69e5aaafdc(["bas_split"]):::uptodate --> xc9200d108e1b2a66(["bas_validate"]):::uptodate
    x4b217d550d08ada0(["bas_data"]):::uptodate --> x1bf6c3824c366cb1(["bas_cleaned"]):::uptodate
    xdb35712610fbc604(["bas_linear_model"]):::uptodate --> x79fe21176be90f97(["bas_lm_coefplot"]):::uptodate
    xb8aa5e15e9f1f7b2(["bas_train"]):::uptodate --> xe22e80ea1c77ed8b(["bas_train_prepped"]):::uptodate
    x1bf6c3824c366cb1(["bas_cleaned"]):::uptodate --> x3e4c5a69e5aaafdc(["bas_split"]):::uptodate
    x3e4c5a69e5aaafdc(["bas_split"]):::uptodate --> xb8aa5e15e9f1f7b2(["bas_train"]):::uptodate
    xdb35712610fbc604(["bas_linear_model"]):::uptodate --> x1e7dc8900c0252af(["model_diagnostics"]):::uptodate
    xb8aa5e15e9f1f7b2(["bas_train"]):::uptodate --> x1e7dc8900c0252af(["model_diagnostics"]):::uptodate
    xe22e80ea1c77ed8b(["bas_train_prepped"]):::uptodate --> x1e7dc8900c0252af(["model_diagnostics"]):::uptodate
    xc9200d108e1b2a66(["bas_validate"]):::uptodate --> x1e7dc8900c0252af(["model_diagnostics"]):::uptodate
    x12e75493b9005333(["bas_validate_prepped"]):::uptodate --> x1e7dc8900c0252af(["model_diagnostics"]):::uptodate
    x79fe21176be90f97(["bas_lm_coefplot"]):::uptodate --> xf8bd9369e68bca9a(["lm_coefplot_file"]):::uptodate
    x1bf6c3824c366cb1(["bas_cleaned"]):::uptodate --> x608f26fc87c17c04(["bas_corrplot"]):::uptodate
    xe22e80ea1c77ed8b(["bas_train_prepped"]):::uptodate --> xdb35712610fbc604(["bas_linear_model"]):::uptodate
    x6e52cb0f1668cc22(["readme"]):::started --> x6e52cb0f1668cc22(["readme"]):::started
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef started stroke:#000000,color:#000000,fill:#DC863B;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 20 stroke-width:0px;
```

</details>

-   This project requires R 4.2.0. This project uses the
    [{renv}](https://rstudio.github.io/renv/) framework to record R
    package dependencies and versions. Packages used are recorded in
    `renv.lock` and code used to manage dependencies is in `renv/` and
    other files in the root project directory. On starting an R session
    in the working directory, run `renv::restore()` to install R package
    dependencies.
    -   The package also requires
        [`cmdstan`](https://mc-stan.org/users/interfaces/cmdstan) to be
        installed. (Version 2.29.2 was used). If not already installed,
        run `cmdstanr::install_cmdstan(version = "2.29.2")` after
        `renv::restore()`
