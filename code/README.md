# Code Directory

This directory contains the analysis script associated with the current manuscript revision.

## File

- `FB_ABT_unload_final_2025.12.Rmd`: public entrypoint that sources the modular analysis scripts

## Analysis modules

- `R/00_setup.R`
- `R/01_data_standardization.R`
- `R/02_multivariate_analysis.R`
- `R/03_mixed_models.R`
- `R/04_interomics_network.R`
- `R/05_mediation_sensitivity.R`

## Manuscript-oriented workflows

- `workflows/01_preterm_gut_overview.R`
- `workflows/02_nicu_exposures_microbiome.R`
- `workflows/03_antibiotic_regimen_effects.R`
- `workflows/04_metabolome_interomics.R`
- `workflows/05_calprotectin_axis.R`

The public script uses standardized column names such as `sample_id`, `infant_id`, and `postnatal_age_days` so that the workflow is easier to read outside the internal project environment.

Input objects should be prepared according to the Methods and supplementary tables.
