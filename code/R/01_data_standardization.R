rename_present <- function(data, mapping) {
  mapping <- mapping[!is.na(mapping)]
  present_mapping <- mapping[unname(mapping) %in% colnames(data)]

  if (length(present_mapping) == 0) {
    return(data)
  }

  rename_calls <- stats::setNames(
    lapply(unname(present_mapping), rlang::sym),
    names(present_mapping)
  )

  dplyr::rename(data, !!!rename_calls)
}

first_non_missing <- function(x) {
  values <- x[!is.na(x)]
  if (length(values) == 0) {
    return(NA)
  }
  values[[1]]
}

recode_binary_flag <- function(x) {
  dplyr::case_when(
    x %in% c("T", "Yes", "YES", "True", "true", 1) ~ "Yes",
    x %in% c("F", "No", "NO", "False", "false", 0) ~ "No",
    TRUE ~ as.character(x)
  )
}

recode_delivery_mode <- function(x) {
  dplyr::case_when(
    x %in% c("VD", "Vaginal") ~ "Vaginal",
    x %in% c("CS", "C-section", "Cesarean") ~ "C-section",
    TRUE ~ as.character(x)
  )
}

recode_sex <- function(x) {
  dplyr::case_when(
    x %in% c("M", "Male") ~ "Male",
    x %in% c("F", "Female") ~ "Female",
    TRUE ~ as.character(x)
  )
}

available_columns <- function(data, columns) {
  intersect(columns, colnames(data))
}

standardize_study_table <- function(
  data,
  sample_id_col = "sample_id",
  infant_id_col = "infant_id",
  postnatal_age_col = "postnatal_age_days",
  gestational_age_col = "gestational_age_weeks",
  birth_weight_col = "birth_weight_g",
  sex_col = "sex",
  delivery_mode_col = "delivery_mode",
  multiple_gestation_col = "multiple_gestation",
  prenatal_antibiotic_col = "prenatal_antibiotics",
  apgar5_col = "apgar_5min",
  breastmilk_ratio_total_col = "breastmilk_exposure_ratio_total",
  formula_ratio_total_col = "formula_exposure_ratio_total",
  antibiotic_ratio_total_col = "antibiotic_exposure_ratio_total",
  antifungal_ratio_total_col = "antifungal_exposure_ratio_total",
  invasive_ventilation_ratio_total_col = "invasive_ventilation_ratio_total",
  central_line_ratio_total_col = "central_line_ratio_total",
  probiotics_ratio_total_col = "probiotics_ratio_total",
  ppi_ratio_total_col = "ppi_ratio_total",
  rbc_transfusion_ratio_total_col = "rbc_transfusion_ratio_total",
  microbial_load_log_col = "microbial_load_log10",
  calprotectin_log_col = "fecal_calprotectin_log",
  additional_mapping = NULL
) {
  base_mapping <- c(
    sample_id = sample_id_col,
    infant_id = infant_id_col,
    postnatal_age_days = postnatal_age_col,
    gestational_age_weeks = gestational_age_col,
    birth_weight_g = birth_weight_col,
    sex = sex_col,
    delivery_mode = delivery_mode_col,
    multiple_gestation = multiple_gestation_col,
    prenatal_antibiotics = prenatal_antibiotic_col,
    apgar_5min = apgar5_col,
    breastmilk_exposure_ratio_total = breastmilk_ratio_total_col,
    formula_exposure_ratio_total = formula_ratio_total_col,
    antibiotic_exposure_ratio_total = antibiotic_ratio_total_col,
    antifungal_exposure_ratio_total = antifungal_ratio_total_col,
    invasive_ventilation_ratio_total = invasive_ventilation_ratio_total_col,
    central_line_ratio_total = central_line_ratio_total_col,
    probiotics_ratio_total = probiotics_ratio_total_col,
    ppi_ratio_total = ppi_ratio_total_col,
    rbc_transfusion_ratio_total = rbc_transfusion_ratio_total_col,
    microbial_load_log10 = microbial_load_log_col,
    fecal_calprotectin_log = calprotectin_log_col
  )

  if (!is.null(additional_mapping)) {
    base_mapping <- c(base_mapping, additional_mapping)
  }

  data_standardized <- data %>%
    rename_present(base_mapping)

  stopifnot("sample_id" %in% colnames(data_standardized))
  stopifnot("infant_id" %in% colnames(data_standardized))

  data_standardized <- data_standardized %>%
    distinct(sample_id, .keep_all = TRUE)

  if ("sex" %in% colnames(data_standardized)) {
    data_standardized <- data_standardized %>%
      mutate(sex = factor(recode_sex(sex), levels = c("Male", "Female")))
  }

  if ("delivery_mode" %in% colnames(data_standardized)) {
    data_standardized <- data_standardized %>%
      mutate(delivery_mode = factor(recode_delivery_mode(delivery_mode), levels = c("Vaginal", "C-section")))
  }

  if ("prenatal_antibiotics" %in% colnames(data_standardized)) {
    data_standardized <- data_standardized %>%
      mutate(prenatal_antibiotics = factor(recode_binary_flag(prenatal_antibiotics), levels = c("No", "Yes")))
  }

  if ("multiple_gestation" %in% colnames(data_standardized)) {
    data_standardized <- data_standardized %>%
      mutate(multiple_gestation = factor(recode_binary_flag(multiple_gestation), levels = c("No", "Yes")))
  }

  numeric_columns <- intersect(
    c(
      "postnatal_age_days",
      "gestational_age_weeks",
      "birth_weight_g",
      "apgar_5min",
      "breastmilk_exposure_ratio_total",
      "formula_exposure_ratio_total",
      "antibiotic_exposure_ratio_total",
      "antifungal_exposure_ratio_total",
      "invasive_ventilation_ratio_total",
      "central_line_ratio_total",
      "probiotics_ratio_total",
      "ppi_ratio_total",
      "rbc_transfusion_ratio_total",
      "microbial_load_log10",
      "fecal_calprotectin_log"
    ),
    colnames(data_standardized)
  )

  data_standardized %>%
    mutate(across(all_of(numeric_columns), as.numeric))
}

rescale_numeric_columns <- function(data, columns, method = c("none", "zscore", "minmax")) {
  method <- match.arg(method)
  columns <- intersect(columns, colnames(data))

  if (length(columns) == 0 || method == "none") {
    return(data)
  }

  if (method == "zscore") {
    data %>%
      mutate(across(all_of(columns), ~ as.numeric(scale(.x))))
  } else {
    data %>%
      mutate(
        across(
          all_of(columns),
          ~ (.x - min(.x, na.rm = TRUE)) / (max(.x, na.rm = TRUE) - min(.x, na.rm = TRUE))
        )
      )
  }
}
