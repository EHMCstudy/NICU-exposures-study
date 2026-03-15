# Code Directory

This directory contains the public analysis script currently associated with the manuscript revision package.

## Included File

- `FB_ABT_unload_final_2025.12.Rmd`: primary R Markdown analysis script covering data cleaning, longitudinal modeling, multivariate statistics, metabolite-network analyses, and mediation analyses.

## Current Scope

This first public release is intended to make the analysis logic visible and citable during manuscript revision. The script is not yet distributed as a fully turnkey pipeline and expects users to prepare the required input objects according to the manuscript Methods, supplementary tables, and future repository documentation.

## Recommended Future Improvements

- add an input schema or data dictionary for required objects
- add a dependency lockfile or session manifest
- split figure-generation and statistics workflows into separate entrypoint scripts if a cleaner public release is needed
