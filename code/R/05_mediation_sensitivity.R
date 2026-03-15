run_subject_level_mediation_sensitivity <- function(data, exposure, mediator, outcome,
                                                    covariates = NULL,
                                                    subject_id_col = "infant_id",
                                                    age_col = "postnatal_age_days",
                                                    min_age_days = NULL,
                                                    sims = 1000) {
  model_columns <- unique(c(subject_id_col, exposure, mediator, outcome, covariates, age_col))
  model_columns <- available_columns(data, model_columns)
  model_data <- data %>% select(all_of(model_columns))

  if (!is.null(min_age_days) && age_col %in% colnames(model_data)) {
    model_data <- model_data %>% filter(.data[[age_col]] >= min_age_days)
  }

  subject_level_data <- model_data %>%
    group_by(.data[[subject_id_col]]) %>%
    summarise(
      across(
        -all_of(subject_id_col),
        ~ if (is.numeric(.x)) median(.x, na.rm = TRUE) else first_non_missing(.x)
      ),
      .groups = "drop"
    ) %>%
    tidyr::drop_na(all_of(c(exposure, mediator, outcome)))

  mediator_model <- lm(
    as.formula(paste(mediator, "~", paste(c(exposure, available_columns(subject_level_data, covariates)), collapse = " + "))),
    data = subject_level_data
  )

  outcome_model <- lm(
    as.formula(paste(outcome, "~", paste(c(exposure, mediator, available_columns(subject_level_data, covariates)), collapse = " + "))),
    data = subject_level_data
  )

  mediation_result <- mediate(
    mediator_model,
    outcome_model,
    treat = exposure,
    mediator = mediator,
    boot = TRUE,
    sims = sims
  )

  data.frame(
    n_infants = nrow(subject_level_data),
    ACME = mediation_result$d0,
    ADE = mediation_result$z0,
    Total_Effect = mediation_result$tau.coef,
    Prop_Mediated = mediation_result$n0,
    P_ACME = mediation_result$d0.p
  )
}
