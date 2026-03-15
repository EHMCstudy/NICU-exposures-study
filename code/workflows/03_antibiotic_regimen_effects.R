# Representative workflow:
# Figure 3 / "Differential impact of antibiotic regimens on microbial diversity and anaerobic colonization"

source(file.path("code", "R", "00_setup.R"))
source(file.path("code", "R", "01_data_standardization.R"))
source(file.path("code", "R", "02_multivariate_analysis.R"))
source(file.path("code", "R", "03_mixed_models.R"))

# Expected inputs after standardization:
# - study_table
# - microbiome_feature_matrix

# 1. Standardize the analysis table and include regimen-specific exposure ratios.
# study_table <- standardize_study_table(
#   raw_study_table,
#   additional_mapping = c(
#     beta_lactam_inhibitor_ratio_total = "your_beta_lactam_ratio_total_column",
#     cephalosporin_ratio_total = "your_cephalosporin_ratio_total_column",
#     carbapenem_ratio_total = "your_carbapenem_ratio_total_column",
#     nitroimidazole_ratio_total = "your_nitroimidazole_ratio_total_column"
#   )
# )

# 2. Estimate regimen-specific adjusted coefficients for diversity and dominant taxa.
# regimen_effects <- run_heatmap_models(
#   data = study_table,
#   outcomes = c(
#     "shannon_index",
#     "microbial_load_log10",
#     "clostridium_sensu_stricto_1_abundance",
#     "veillonella_abundance"
#   ),
#   focal_exposure = "beta_lactam_inhibitor_ratio_total",
#   covariates = c(
#     "postnatal_age_days",
#     "gestational_age_weeks",
#     "birth_weight_g",
#     "breastmilk_exposure_ratio_total",
#     "formula_exposure_ratio_total",
#     "antifungal_exposure_ratio_total",
#     "probiotics_ratio_total"
#   ),
#   subject_id_col = "infant_id",
#   rescale_columns = c("postnatal_age_days", "beta_lactam_inhibitor_ratio_total"),
#   rescale_method = "minmax"
# )

# 3. Repeat the same framework for other regimen-specific variables as needed.
