# Representative workflow:
# Figure 1 / "Obligate anaerobes orchestrate microbial diversity in the pathobiont-dominated preterm gut"

source(file.path("code", "R", "00_setup.R"))
source(file.path("code", "R", "01_data_standardization.R"))
source(file.path("code", "R", "02_multivariate_analysis.R"))
source(file.path("code", "R", "03_mixed_models.R"))

# Expected inputs after standardization:
# - study_table
# - family_abundance_long
# - microbiome_bray_distance

# 1. Standardize the sample-level analysis table.
# study_table <- standardize_study_table(raw_study_table, ...)

# 2. Plot ordered family composition and microbial load trajectories.
# figure_1d <- plot_ordered_composition_bar(
#   data_long = family_abundance_long,
#   abundance_col = "family_abundance"
# )

# 3. Quantify the effect of postnatal age on microbial load and diversity.
# age_model_load <- fit_adjusted_mixed_model(
#   data = study_table,
#   outcome = "microbial_load_log10",
#   exposure = "postnatal_age_days",
#   subject_id_col = "infant_id",
#   rescale_columns = c("postnatal_age_days"),
#   rescale_method = "minmax"
# )
#
# age_model_diversity <- fit_adjusted_mixed_model(
#   data = study_table,
#   outcome = "shannon_index",
#   exposure = "postnatal_age_days",
#   subject_id_col = "infant_id",
#   rescale_columns = c("postnatal_age_days"),
#   rescale_method = "minmax"
# )

# 4. Summarize diversity- and load-associated taxa if required.
# phenotype_models <- run_heatmap_models(
#   data = study_table,
#   outcomes = c("microbial_load_log10", "shannon_index"),
#   focal_exposure = "obligate_anaerobe_abundance",
#   covariates = c("postnatal_age_days"),
#   subject_id_col = "infant_id",
#   rescale_columns = c("postnatal_age_days", "obligate_anaerobe_abundance"),
#   rescale_method = "minmax"
# )
