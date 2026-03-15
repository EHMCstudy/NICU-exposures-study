# Representative workflow:
# Figure 4 / "NICU interventions reprogram fecal metabolome by disrupting anaerobe-metabolite associations"

source(file.path("code", "R", "00_setup.R"))
source(file.path("code", "R", "01_data_standardization.R"))
source(file.path("code", "R", "02_multivariate_analysis.R"))
source(file.path("code", "R", "04_interomics_network.R"))

# Expected inputs after standardization:
# - study_table
# - metabolite_matrix
# - microbiome_matrix
# - microbiome_bray_distance
# - metabolome_euclidean_distance

# 1. Quantify the contribution of clinical exposures to metabolomic variation.
# metabolome_permanova <- run_permanova_summary(
#   distance_matrix = metabolome_euclidean_distance,
#   metadata = study_table,
#   variables = c(
#     "postnatal_age_days",
#     "breastmilk_exposure_ratio_total",
#     "formula_exposure_ratio_total",
#     "antibiotic_exposure_ratio_total"
#   )
# )

# 2. Generate adjusted ordination summaries for metabolome-associated exposures.
# metabolome_dbrda <- run_dbrda_summary(
#   feature_matrix = metabolite_matrix,
#   metadata = study_table,
#   variables = c(
#     "postnatal_age_days",
#     "breastmilk_exposure_ratio_total",
#     "formula_exposure_ratio_total",
#     "antibiotic_exposure_ratio_total"
#   ),
#   distance_method = "euclidean"
# )

# 3. Quantify microbiome-metabolome concordance.
# procrustes_result <- run_procrustes_summary(
#   microbiome_distance = microbiome_bray_distance,
#   metabolite_distance = metabolome_euclidean_distance
# )

# 4. Build the inter-omics network corresponding to the manuscript network framework.
# network_result <- build_metanet_interomics_network(
#   microbiome_matrix = microbiome_matrix,
#   metabolite_matrix = metabolite_matrix,
#   r_threshold = 0.3,
#   p_threshold = 0.01
# )
