# NICU-exposures-study

Public code and metadata companion repository for the manuscript:

`Neonatal Intensive Care Unit Exposures Reprogram Microbiome-Metabolome Trajectories and Modulate Host Calprotectin in Preterm Infants: A Longitudinal Multi-omics Study`

## Current Status

- Repository URL for manuscript citation: [https://github.com/EHMCstudy/NICU-exposures-study](https://github.com/EHMCstudy/NICU-exposures-study)
- Public sequencing repository: [NCBI BioProject PRJNA1163054](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1163054)
- Public metabolomics repository: Zenodo record to be linked after registration and verification
- Public sample-level metadata: pending final release approval and accession crosswalk completion

## What This Repository Contains

- `code/`: analysis scripts used to generate the manuscript results and figures
- `docs/`: manuscript-facing availability text and public-release checklist
- `data/metadata/`: de-identified public metadata tables intended for release after QC and approval

## Reproducibility Notes

The current public code release is script-based and expects users to prepare analysis inputs according to the manuscript Methods and supplementary tables. A more fully packaged reproducibility layer can be added in a later release if needed.

For the current submission/revision cycle, this repository is intended to provide:

1. The primary analysis script used for manuscript-level analyses.
2. Public-facing documentation describing code and data availability.
3. A stable GitHub location that can be cited in the manuscript and response letter.

## Planned Additions

- De-identified sample-level metadata table for public reuse
- Accession crosswalk columns linking public metadata rows to SRA/BioSample objects when approved
- Release tag for the manuscript-associated public version
- Optional Zenodo archive of the GitHub release for DOI-based software citation

## Repository Structure

```text
NICU-exposures-study/
├── code/
├── data/
│   └── metadata/
└── docs/
```

## Citation Guidance

Until a tagged release is created, cite the repository URL directly in the manuscript:

`https://github.com/EHMCstudy/NICU-exposures-study`

Once a release is created, update the manuscript to cite the release URL or archived DOI.
