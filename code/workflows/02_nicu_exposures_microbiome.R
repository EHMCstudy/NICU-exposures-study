# Representative workflow:
# Figure 2 / "NICU Exposures Shape Microbial Colonization Patterns"

source(file.path("code", "R", "00_setup.R"))
source(file.path("code", "R", "01_data_standardization.R"))
source(file.path("code", "R", "02_multivariate_analysis.R"))
source(file.path("code", "R", "03_mixed_models.R"))

# Expected inputs after standardization:
# - study_table
# - genus_or_family_feature_matrix
# - microbiome_bray_distance

# 1. Standardize the sample-level table.
# study_table <- standardize_study_table(raw_study_table, ...)

# 2. Quantify global microbiome associations with NICU exposures.
# exposure_variables <- c(
#   "postnatal_age_days",
#   "gestational_age_weeks",
#   "birth_weight_g",
#   "breastmilk_exposure_ratio_total",
#   "formula_exposure_ratio_total",
#   "antibiotic_exposure_ratio_total",
#   "antifungal_exposure_ratio_total",
#   "probiotics_ratio_total",
#   "ppi_ratio_total",
#   "rbc_transfusion_ratio_total"
# )
#
# microbiome_permanova <- run_permanova_summary(
#   distance_matrix = microbiome_bray_distance,
#   metadata = study_table,
#   variables = exposure_variables
# )

# 3. Build the adjusted dbRDA summary used for exposure-direction visualization.
# microbiome_dbrda <- run_dbrda_summary(
#   feature_matrix = genus_or_family_feature_matrix,
#   metadata = study_table,
#   variables = exposure_variables
# )
#
# figure_2c <- plot_dbrda_biplot(
#   dbrda_result = microbiome_dbrda,
#   metadata = study_table,
#   fill_col = "shannon_index"
# )

# 4. Estimate adjusted mixed-effects coefficients for one focal exposure across outcomes.
# antibiotic_effects <- run_heatmap_models(
#   data = study_table,
#   outcomes = c("microbial_load_log10", "shannon_index", "obligate_anaerobe_abundance"),
#   focal_exposure = "antibiotic_exposure_ratio_total",
#   covariates = c(
#     "gestational_age_weeks",
#     "birth_weight_g",
#     "sex",
#     "delivery_mode",
#     "multiple_gestation",
#     "prenatal_antibiotics",
#     "apgar_5min",
#     "postnatal_age_days",
#     "breastmilk_exposure_ratio_total",
#     "formula_exposure_ratio_total",
#     "antifungal_exposure_ratio_total",
#     "probiotics_ratio_total",
#     "ppi_ratio_total",
#     "rbc_transfusion_ratio_total"
#   ),
#   subject_id_col = "infant_id",
#   rescale_columns = c("postnatal_age_days", "antibiotic_exposure_ratio_total"),
#   rescale_method = "minmax"
# )
