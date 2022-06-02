#!/usr/bin/env Rscript

# This is a helper script to run the pipeline.
# Choose how to execute the pipeline below.
# See https://books.ropensci.org/targets/hpc.html
# to learn about your options.

# Prior to running this script, run `renv::restore()`
# (running `install.packages('renv')` if neccessary first).
# This will install all the packages listed in `renv.lock`
# needed to run this analysis.  cmdstan may also need to be
# installed afterwords, which can be done with
# `cmdstanr::install_cmdstan(version = "2.29.2")`

targets::tar_make()
# targets::tar_make_clustermq(workers = 2) # nolint
# targets::tar_make_future(workers = 2) # nolint
