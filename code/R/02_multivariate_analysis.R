plot_ordered_composition_bar <- function(data_long, abundance_col, family_col = "Family") {
  ggplot(
    data_long,
    aes(
      x = forcats::fct_reorder(sample_id, microbial_load_log10),
      y = .data[[abundance_col]],
      fill = .data[[family_col]]
    )
  ) +
    geom_col(width = 1) +
    scale_fill_manual(values = family_palette) +
    labs(x = "Samples", y = abundance_col) +
    theme_publication +
    theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())
}

plot_effect_size_forest <- function(results_table, label_col = "Variable", effect_col = "Effect",
                                    ci_low_col = "CI_low", ci_high_col = "CI_high",
                                    y_label = "Normalized effect size") {
  ggplot(results_table, aes(x = forcats::fct_reorder(.data[[label_col]], .data[[effect_col]]),
                            y = .data[[effect_col]])) +
    geom_point(size = 2) +
    geom_errorbar(aes(ymin = .data[[ci_low_col]], ymax = .data[[ci_high_col]]), width = 0.2) +
    coord_flip() +
    geom_hline(yintercept = 0, color = "red4", linetype = "dashed", alpha = 0.7) +
    labs(x = NULL, y = y_label) +
    theme_publication
}

as_distance_matrix <- function(x, method) {
  if (inherits(x, "dist")) {
    return(x)
  }
  vegan::vegdist(as.matrix(x), method = method)
}

align_metadata_to_distance <- function(distance_matrix, metadata, sample_id_col = "sample_id") {
  sample_ids <- labels(distance_matrix)
  metadata %>%
    filter(.data[[sample_id_col]] %in% sample_ids) %>%
    tibble::column_to_rownames(sample_id_col) %>%
    .[sample_ids, , drop = FALSE]
}

run_permanova_summary <- function(distance_matrix, metadata, variables,
                                  sample_id_col = "sample_id",
                                  permutations = 2000,
                                  p_adjust_method = "fdr") {
  distance_matrix <- as_distance_matrix(distance_matrix, method = "bray")
  metadata_aligned <- align_metadata_to_distance(distance_matrix, metadata, sample_id_col = sample_id_col)

  model_variables <- available_columns(metadata_aligned, variables)
  stopifnot(length(model_variables) > 0)

  formula_text <- paste("distance_matrix ~", paste(model_variables, collapse = " + "))
  permanova_result <- vegan::adonis2(
    as.formula(formula_text),
    data = metadata_aligned,
    permutations = permutations,
    by = "margin"
  )

  as.data.frame(permanova_result) %>%
    tibble::rownames_to_column("Variable") %>%
    filter(!Variable %in% c("Total", "Residual")) %>%
    mutate(P_adj = p.adjust(`Pr(>F)`, method = p_adjust_method)) %>%
    arrange(desc(R2))
}

run_dbrda_summary <- function(feature_matrix, metadata, variables,
                              sample_id_col = "sample_id",
                              distance_method = "bray",
                              permutations = 2000,
                              p_adjust_method = "fdr") {
  feature_matrix <- as.data.frame(feature_matrix)
  metadata_aligned <- metadata %>%
    filter(.data[[sample_id_col]] %in% rownames(feature_matrix)) %>%
    tibble::column_to_rownames(sample_id_col)
  metadata_aligned <- metadata_aligned[rownames(feature_matrix), , drop = FALSE]

  model_variables <- available_columns(metadata_aligned, variables)
  stopifnot(length(model_variables) > 0)

  formula_text <- paste("feature_matrix ~", paste(model_variables, collapse = " + "))
  dbrda_model <- vegan::capscale(as.formula(formula_text), data = metadata_aligned, dist = distance_method)

  anova_table <- anova(dbrda_model, by = "margin", permutations = permutations) %>%
    as.data.frame() %>%
    tibble::rownames_to_column("Variable") %>%
    filter(Variable != "Residual") %>%
    mutate(P_adj = p.adjust(`Pr(>F)`, method = p_adjust_method))

  list(
    model = dbrda_model,
    anova_table = anova_table,
    sites = as.data.frame(vegan::scores(dbrda_model, display = "sites", choices = 1:2)) %>%
      tibble::rownames_to_column("sample_id"),
    vectors = as.data.frame(vegan::scores(dbrda_model, display = "bp", choices = 1:2)) %>%
      tibble::rownames_to_column("Variable")
  )
}

plot_dbrda_biplot <- function(dbrda_result, metadata,
                              fill_col = "postnatal_age_days",
                              arrow_multiplier = 3) {
  significant_vectors <- dbrda_result$vectors %>%
    left_join(dbrda_result$anova_table %>% select(Variable, P_adj), by = "Variable") %>%
    filter(P_adj < 0.1)

  site_table <- dbrda_result$sites %>%
    left_join(metadata, by = "sample_id")

  ggplot() +
    geom_point(
      data = site_table,
      aes(x = CAP1, y = CAP2, fill = .data[[fill_col]]),
      shape = 21,
      size = 2.5,
      alpha = 0.8
    ) +
    geom_segment(
      data = significant_vectors,
      aes(x = 0, y = 0, xend = CAP1 * arrow_multiplier, yend = CAP2 * arrow_multiplier),
      arrow = arrow(length = unit(0.2, "cm")),
      color = "black"
    ) +
    geom_text_repel(
      data = significant_vectors,
      aes(x = CAP1 * arrow_multiplier * 1.1, y = CAP2 * arrow_multiplier * 1.1, label = Variable),
      size = 3
    ) +
    scale_fill_gradient(low = "grey85", high = "#2C7FB8") +
    labs(x = "dbRDA1", y = "dbRDA2") +
    theme_publication
}
