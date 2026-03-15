run_procrustes_summary <- function(microbiome_distance, metabolite_distance,
                                   permutations = 2000) {
  microbiome_distance <- as_distance_matrix(microbiome_distance, method = "bray")
  metabolite_distance <- as_distance_matrix(metabolite_distance, method = "euclidean")

  shared_ids <- intersect(labels(microbiome_distance), labels(metabolite_distance))
  microbiome_distance <- as.dist(as.matrix(microbiome_distance)[shared_ids, shared_ids])
  metabolite_distance <- as.dist(as.matrix(metabolite_distance)[shared_ids, shared_ids])

  protest_result <- vegan::protest(
    microbiome_distance,
    metabolite_distance,
    scores = "sites",
    permutations = permutations
  )

  list(
    test = protest_result,
    plot_table = data.frame(
      sample_id = shared_ids,
      microbiome_axis1 = protest_result$X[, 1],
      microbiome_axis2 = protest_result$X[, 2],
      metabolite_axis1 = protest_result$Yrot[, 1],
      metabolite_axis2 = protest_result$Yrot[, 2]
    )
  )
}

plot_procrustes_summary <- function(procrustes_result) {
  ggplot(procrustes_result$plot_table) +
    geom_segment(
      aes(
        x = microbiome_axis1,
        y = microbiome_axis2,
        xend = metabolite_axis1,
        yend = metabolite_axis2
      ),
      color = "grey80",
      alpha = 0.5
    ) +
    geom_point(aes(x = microbiome_axis1, y = microbiome_axis2), color = "#E64B35FF", size = 2) +
    geom_point(aes(x = metabolite_axis1, y = metabolite_axis2), color = "#4DBBD5FF", size = 2) +
    annotate(
      "text",
      x = min(procrustes_result$plot_table$microbiome_axis1),
      y = max(procrustes_result$plot_table$microbiome_axis2),
      label = paste0(
        "Procrustes t0 = ",
        round(procrustes_result$test$t0, 3),
        "\nP = ",
        procrustes_result$test$signif
      )
    ) +
    labs(x = "Axis 1", y = "Axis 2") +
    theme_publication
}

build_metanet_interomics_network <- function(microbiome_matrix, metabolite_matrix,
                                             r_threshold = 0.3,
                                             p_threshold = 0.01,
                                             use_p_adj = TRUE,
                                             delete_single = TRUE) {
  if (!requireNamespace("MetaNet", quietly = TRUE)) {
    stop("MetaNet package is required for network analysis.")
  }

  shared_ids <- intersect(rownames(microbiome_matrix), rownames(metabolite_matrix))
  microbiome_matrix <- as.data.frame(microbiome_matrix[shared_ids, , drop = FALSE])
  metabolite_matrix <- as.data.frame(metabolite_matrix[shared_ids, , drop = FALSE])

  network_object <- MetaNet::multi_net_build(
    list(Microbiome = microbiome_matrix, Metabolome = metabolite_matrix),
    r_threshold = r_threshold,
    p_threshold = p_threshold,
    use_p_adj = use_p_adj,
    delete_single = delete_single
  )

  list(
    network = network_object,
    edge_table = as.data.frame(MetaNet::get_e(network_object))
  )
}
