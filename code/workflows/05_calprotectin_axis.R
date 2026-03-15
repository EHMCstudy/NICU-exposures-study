# Representative workflow:
# Figure 5 / "Antibiotic-driven loss of anaerobes and polyamines is linked to impaired S100A8/A9 immune responses"

source(file.path("code", "R", "00_setup.R"))
source(file.path("code", "R", "01_data_standardization.R"))
source(file.path("code", "R", "03_mixed_models.R"))
source(file.path("code", "R", "05_mediation_sensitivity.R"))

# Expected inputs after standardization:
# - study_table

# 1. Estimate adjusted mixed-effects associations for calprotectin.
# calprotectin_effects <- run_heatmap_models(
#   data = study_table,
#   outcomes = c("fecal_calprotectin_log"),
#   focal_exposure = "antibiotic_exposure_ratio_total",
#   covariates = c(
#     "postnatal_age_days",
#     "gestational_age_weeks",
#     "birth_weight_g",
#     "breastmilk_exposure_ratio_total",
#     "formula_exposure_ratio_total",
#     "ppi_ratio_total",
#     "rbc_transfusion_ratio_total"
#   ),
#   subject_id_col = "infant_id",
#   rescale_columns = c("postnatal_age_days", "antibiotic_exposure_ratio_total"),
#   rescale_method = "minmax"
# )

# 2. Run a conservative infant-level mediation sensitivity analysis.
# mediation_result <- run_subject_level_mediation_sensitivity(
#   data = study_table,
#   exposure = "antibiotic_exposure_ratio_total",
#   mediator = "clostridium_sensu_stricto_1_abundance",
#   outcome = "fecal_calprotectin_log",
#   covariates = c("postnatal_age_days"),
#   subject_id_col = "infant_id",
#   age_col = "postnatal_age_days",
#   min_age_days = 14
# )
