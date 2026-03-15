fit_adjusted_mixed_model <- function(data, outcome, exposure, covariates = NULL,
                                     subject_id_col = "infant_id",
                                     rescale_columns = NULL,
                                     rescale_method = c("none", "minmax", "zscore")) {
  model_columns <- unique(c(subject_id_col, outcome, exposure, covariates))
  model_columns <- available_columns(data, model_columns)

  model_data <- data %>%
    select(all_of(model_columns)) %>%
    tidyr::drop_na(all_of(c(outcome, exposure, subject_id_col)))

  rescale_targets <- if (is.null(rescale_columns)) character(0) else rescale_columns
  model_data <- rescale_numeric_columns(
    model_data,
    columns = intersect(rescale_targets, colnames(model_data)),
    method = match.arg(rescale_method)
  )

  rhs_terms <- c(exposure, available_columns(model_data, covariates))
  model_formula <- as.formula(paste(outcome, "~", paste(rhs_terms, collapse = " + ")))

  nlme::lme(
    fixed = model_formula,
    random = as.formula(paste("~1|", subject_id_col)),
    data = model_data,
    na.action = na.omit
  )
}

extract_model_results <- function(model_object) {
  as.data.frame(summary(model_object)$tTable) %>%
    tibble::rownames_to_column("Variable") %>%
    rename(
      Effect = Value,
      Standard_Error = Std.Error,
      Degrees_of_Freedom = DF,
      T_value = `t-value`,
      P_value = `p-value`
    ) %>%
    mutate(
      CI_low = Effect - 1.96 * Standard_Error,
      CI_high = Effect + 1.96 * Standard_Error
    )
}

run_heatmap_models <- function(data, outcomes, focal_exposure, covariates = NULL,
                               subject_id_col = "infant_id",
                               rescale_columns = NULL,
                               rescale_method = c("none", "minmax", "zscore")) {
  results <- lapply(outcomes, function(outcome_name) {
    fitted_model <- fit_adjusted_mixed_model(
      data = data,
      outcome = outcome_name,
      exposure = focal_exposure,
      covariates = covariates,
      subject_id_col = subject_id_col,
      rescale_columns = rescale_columns,
      rescale_method = match.arg(rescale_method)
    )

    extract_model_results(fitted_model) %>%
      filter(Variable == focal_exposure) %>%
      transmute(
        Outcome = outcome_name,
        Exposure = focal_exposure,
        Effect,
        P_value,
        CI_low,
        CI_high
      )
  })

  bind_rows(results)
}

plot_model_heatmap <- function(results_table, value_col = "Effect") {
  heatmap_matrix <- results_table %>%
    select(Outcome, Exposure, .data[[value_col]]) %>%
    pivot_wider(names_from = Exposure, values_from = .data[[value_col]]) %>%
    tibble::column_to_rownames("Outcome") %>%
    as.matrix()

  pheatmap::pheatmap(
    heatmap_matrix,
    color = colorRampPalette(c("navy", "white", "firebrick3"))(100),
    cluster_rows = FALSE,
    cluster_cols = FALSE,
    border_color = "grey90"
  )
}
