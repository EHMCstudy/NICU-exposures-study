if (!requireNamespace("pacman", quietly = TRUE)) {
  install.packages("pacman")
}

pacman::p_load(
  dplyr,
  tidyr,
  ggplot2,
  forcats,
  vegan,
  nlme,
  openxlsx,
  ggrepel,
  pheatmap,
  scales,
  mediation
)

set.seed(123)

theme_publication <- theme_classic() +
  theme(
    axis.text = element_text(color = "black", size = 10),
    axis.title = element_text(color = "black", size = 11, face = "bold"),
    legend.title = element_text(color = "black", face = "bold"),
    legend.text = element_text(color = "black"),
    strip.background = element_blank(),
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

family_palette <- c(
  "Enterobacteriaceae" = "#C0392B",
  "Enterococcaceae" = "#A04000",
  "Staphylococcaceae" = "#F1C40F",
  "Clostridiaceae" = "#E67E22",
  "Bifidobacteriaceae" = "#8E44AD",
  "Veillonellaceae" = "#2C3E50",
  "Streptococcaceae" = "#E74C3C",
  "Other" = "grey80"
)
