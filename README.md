



# CEO Promises Analysis

## Overview

This repository contains the code, data, and methods for the paper:

**"Selling Hope in Times of Need: A Study of CEO Promises as Strategic Communication Tools"**

This study investigates CEO promises as a distinct form of strategic communication, focusing on when and why CEOs make explicit, future-oriented commitments in earnings calls. Using Large Language Models (LLMs), we analyze over 69,000 earnings call transcripts from S&P 1500 firms (2010–2022) to identify, classify, and analyze CEO promises and their antecedents.

---

## Repository Structure

### Data

- **sxp1500_ceo_promises_2010_2022.xlsx**: Database of all identified CEO promises (2010–2022).

- **correlation_table_20240624.rtf**: Correlation matrix for main variables.

- **descriptive_stats_20240624.rtf**: Descriptive statistics for the sample.

- **regression_results_20240624.doc**: Main regression results.

### GPT Prompts

- Directory containing prompt templates used for LLM-based extraction and coding of CEO promises and their characteristics.

### Source Code

| File Name | Description |

|-----------------------------------|----------------------------------------------------------------------------------------------|

| 1_download_transcripts.ipynb | Download earnings call transcripts from WRDS/Capital IQ. |

| 2_prepare_transcripts.ipynb | Prepare and aggregate transcripts for analysis; identify CEO speakers. |

| 3_find_promises.ipynb | Use OpenAI GPT API to identify and extract CEO promises from transcripts. |

| 4_promise_db_cleanup.ipynb | Clean and structure the extracted promises database. |

| 5_promise_horizon_measure.ipynb | Use LLMs to extract and code the time horizon of each promise. |

| 6_promise_specificity_measure.ipynb| Use LLMs to score the specificity of each promise (1–5 scale). |

| 7_promise_topic_model.ipynb | Topic modeling and clustering of promises using LLMs and unsupervised learning. |

| 8_promise_db_explorations.ipynb | Exploratory and descriptive analysis of the promises database. |

| 9_promises_vs_fls.ipynb | Compare CEO promises to forward-looking statements (FLS) using NLP methods. |

| 10_add_regression_vars.ipynb | Merge promise data with financial, CEO, and firm-level variables for regression analysis. |

| 11_regression_analysis_stata.do | Stata do-file for running main and robustness regression models. |

---

## Methods

### Data Collection

- **Transcripts:** Earnings call transcripts were collected from Capital IQ Transcripts via WRDS, covering S&P 1500 firms from 2010 to 2022.

- **CEO Identification:** CEO speakers were identified using Execucomp and BoardEx databases.

### Data Processing & Promise Extraction

- **LLM-Based Extraction:** We used OpenAI’s latest GPT models to semantically identify CEO promises in the presentation sections of earnings calls.

- **Prompt Engineering:** Custom prompts defined what constitutes a CEO promise, with instructions for extracting verbatim text, delivery horizon, and specificity.

- **Batch Processing:** Asynchronous and checkpointed batch processing was used for large-scale LLM calls.

### Promise Characterization

- **Time Horizon:** LLMs were prompted to extract the stated or implied delivery date of each promise (in months).

- **Specificity:** Each promise was scored (1–5) for specificity and measurability using LLMs.

- **Topic Modeling:** Promises were clustered into thematic categories using LLM-generated keywords and unsupervised clustering (UMAP, HDBSCAN).

### Data Assembly & Analysis

- **Merging:** Promise-level data was merged with firm, CEO, and transcript-level variables (financials, performance, uncertainty, etc.).

- **Statistical Analysis:** Main regressions were run in Stata (`reghdfe`, `ppmlhdfe`) to test hypotheses about the antecedents and contexts of CEO promise-making.

- **Exploratory Analysis:** Additional notebooks provide descriptive statistics, visualizations, and robustness checks.

---

## Key Findings

- **CEO promises are more frequent** when CEOs are new, female, or following missed earnings expectations—contexts where managing stakeholder expectations is critical.

- **Promise-making declines** under high uncertainty or resource constraints, when preserving strategic flexibility is more important.

- **Promise characteristics (horizon, specificity, topic)** vary systematically with context, and CEOs use strategic ambiguity (vague timelines, less specificity) especially during periods of uncertainty (e.g., COVID-19).

- **Comprehensive Database:** The project produces the first large-scale, open database of CEO promises, enabling future research on executive communication and strategic signaling.

---

## How to Use This Repository

1. **Prerequisites:**

- Python 3.8+ (for Jupyter notebooks)

- Stata 16+ (for regression analysis)

- WRDS/CIQ access (for transcript download)

- OpenAI API key (for LLM-based scripts)

2. **Reproducing the Pipeline:**

- Run the notebooks in order (`1_download_transcripts.ipynb` → `10_add_regression_vars.ipynb`) to reproduce the data pipeline.

- Use `11_regression_analysis_stata.do` for main regression analyses.

- Data files and prompt templates are provided for reference and reproducibility.

3. **Data Availability:**

- The processed CEO promises database (`sxp1500_ceo_promises_2010_2022.xlsx`) is available for download, subject to data provider restrictions.

---

## Citation

If you use this code or data, please cite:

> [Author Names]. (2024). "Selling Hope in Times of Need: A Study of CEO Promises as Strategic Communication Tools." Working paper. [Add DOI or link when available]

---

## Contact

For questions or issues, please contact [Your Name] at [Your Email].

---

**Last updated:** April 2025
