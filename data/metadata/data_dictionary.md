# Metadata Data Dictionary

## Source

These files were extracted and standardized from `Tables_supplemental-revision.xlsx`, primarily from `Table S1 - Infant` and `Table S2 - Sample`.

## Released files

### `table_s1_infant_summary.csv`

- Cohort-level summary statistics for all infants and infants without NEC.
- Columns:
  - `section`
  - `variable`
  - `all_infants`
  - `infants_without_nec`

### `table_s1_infant_metadata.csv`

- De-identified infant-level metadata.
- Key fields:
  - infant characteristics: gestational age, birth weight, sex, Apgar scores
  - perinatal factors: prenatal antibiotics, PPROM, gestational hypertension, gestational diabetes mellitus
  - NICU exposure durations: antibiotics, human milk, formula, ventilation, central venous catheters, probiotics, supplements
  - outcomes / clinical flags: NEC, sepsis

### `table_s2_sample_counts.csv`

- Sample counts by cohort group and assay type.
- Includes median and interquartile range of sample age at collection.

### `table_s2_sample_metadata.csv`

- De-identified sample-level metadata.
- Key fields:
  - `infant_id`
  - `sample_id`
  - `sample_age_days`
  - assay availability flags:
    - `has_qpcr`
    - `has_16s_rrna_sequencing`
    - `has_untargeted_metabolome`
    - `has_targeted_metabolome`
    - `has_fecal_calprotectin`
  - cumulative exposure variables recorded up to the sampling timepoint

## Standardization notes

- Column names were converted to snake_case for public release.
- Binary assay-status fields were converted to logical values.
- Internal spreadsheet formatting and merged-header structure were removed during export.
