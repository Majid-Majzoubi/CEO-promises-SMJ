# CEO Promises Analysis – Repository

Supporting material for

**"Shaping Expectations, Losing Flexibility: A Study of CEO Promises as Strategic Communication Tools"**  
Majid Majzoubi, Alex Murray, William J. Mayew  
*Strategic Management Journal*, forthcoming (2026)

[**⬇️ DOWNLOAD CEO Promises Database (CSV)**](data/CEO_promises_database_2025.csv)


---

## 1. What's in this repo?

This repository contains all code and documentation to:

1. **Download & clean** 69,248 Capital-IQ earnings-call transcripts (S&P 1500, 2010–2022)
2. **Detect, parse, and label** the 74,017 CEO promises used in the paper
3. **Measure promise characteristics** (horizon, specificity, topics)
4. **Track promise delivery** and analyze CEO dismissal consequences
5. **Assemble the regression database** and run every model reported in the manuscript

### Main Analysis Pipeline

| Notebook / Script                      | Main Task                                                      | Key External Source         |
|---------------------------------------- |--------------------------------------------------------------- |----------------------------|
| **1_download_transcripts.ipynb**        | Pull raw transcripts from WRDS → Capital IQ                    | WRDS credentials           |
| **2_prepare_transcripts.ipynb**         | Limit to S&P1500, identify CEO speakers via Execucomp fuzzy match | WRDS Execucomp            |
| **3_find_promises.ipynb**               | Call OpenAI `o3-mini-2025-01-31` to identify promises          | OpenAI API                 |
| **4_promise_db_cleanup.ipynb**          | Filter to strong commitments, remove financial guidance        | –                          |
| **5_promise_horizon_measure.ipynb**     | GPT `o3-mini` → estimate months-to-delivery                    | OpenAI                     |
| **6_promise_specificity_measure.ipynb** | GPT-4o scores (1 = vague … 5 = precise)                        | OpenAI                     |
| **7_promise_topic_model.ipynb**         | Keyword extraction (Claude-3 Sonnet) + HDBSCAN clustering      | Anthropic API              |
| **8_promise_db_explorations.ipynb**     | Descriptive figures & sanity checks                            | –                          |
| **9_promises_vs_fls.ipynb**             | Compute forward-looking-statement (FLS) ratios using NLTK      | NLTK dictionary            |
| **10_add_regression_vars.ipynb**        | Merge Compustat/Execucomp/IBES/BoardEx/PRisk/EPU/Guidance     | WRDS & public data         |
| **11_regression_analysis_stata.do**     | Main regressions: promise antecedents (`reghdfe`, `ppmlhdfe`)  | Stata 17 SE                |

### CEO Dismissal Analysis (Supplementary)

Located in `src_code/ceo dismissal/`:

| Notebook / Script                                  | Main Task                                                      |
|---------------------------------------------------|----------------------------------------------------------------|
| **promise_follow_up_final.ipynb**                  | Use GPT-5 + web search to audit promise delivery status      |
| **promise_follow_up_batch2_final.ipynb**          | Batch 2 of promise follow-up (continuation)                    |
| **promise_follow_up_regressions_db_final.ipynb**  | Prepare CEO dismissal regression dataset                       |
| **promise_follow_up_regressions_db_batch2_final.ipynb** | Merge batch 2 data for CEO dismissal analysis           |
| **ceo_dismissal_regressions_stata.do**            | CEO dismissal regressions: broken promises → turnover risk     |

---

## 2. Folder layout

```
.
├─ data/
│   ├─ CEO_promises_database_2025.csv  # ⬇️ Main output: 74,017 promises
│   └─ gpt_prompts/                    # LLM prompt templates
│       ├─ promise_system_message.txt
│       ├─ promise_user_message.txt
│       └─ variations/                 # Alternative prompt versions tested
├─ src_code/                           # All analysis notebooks
│   ├─ 1_download_transcripts.ipynb
│   ├─ 2_prepare_transcripts.ipynb
│   ├─ 3_find_promises.ipynb
│   ├─ 4_promise_db_cleanup.ipynb
│   ├─ 5_promise_horizon_measure.ipynb
│   ├─ 6_promise_specificity_measure.ipynb
│   ├─ 7_promise_topic_model.ipynb
│   ├─ 8_promise_db_explorations.ipynb
│   ├─ 9_promises_vs_fls.ipynb
│   ├─ 10_add_regression_vars.ipynb
│   ├─ 11_regression_analysis_stata.do
│   └─ ceo dismissal/                 # Supplementary CEO dismissal analysis
│       ├─ promise_follow_up_final.ipynb
│       ├─ promise_follow_up_batch2_final.ipynb
│       ├─ promise_follow_up_regressions_db_final.ipynb
│       ├─ promise_follow_up_regressions_db_batch2_final.ipynb
│       └─ ceo_dismissal_regressions_stata.do
├─ LICENSE
├─ README.md
└─ requirements.txt
```

---

## 3. Quick start

### Prerequisites

- **Python 3.10+** (3.11 recommended)
- **Stata 17 SE** (with `reghdfe` and `ppmlhdfe` packages)
- **WRDS account** with access to Capital IQ, Compustat, Execucomp, IBES
- **OpenAI API key** (for notebooks 3, 5, 6, and CEO dismissal analysis)
- **Anthropic API key** (for notebook 7 only)

### Installation

```bash
git clone https://github.com/your-handle/ceo-promises.git
cd ceo-promises

# Create virtual environment
conda create -n ceo_promises python=3.10
conda activate ceo_promises

# Install Python dependencies
pip install -r requirements.txt

# For NLTK (notebook 9), download required data
python -m nltk.downloader punkt
```

### Set environment variables

**Important:** Do *not* hard-code API keys in notebooks. Set them as environment variables:

```bash
export WRDS_USERNAME=your_wrds_username
export WRDS_PASSWORD=your_wrds_password
export OPENAI_API_KEY=sk-your-openai-key
export ANTHROPIC_API_KEY=sk-your-anthropic-key
```

Or create a `.env` file in the project root:

```
WRDS_USERNAME=your_wrds_username
WRDS_PASSWORD=your_wrds_password
OPENAI_API_KEY=sk-your-openai-key
ANTHROPIC_API_KEY=sk-your-anthropic-key
```

### Running the analysis

1. **Place required data files** (see Section 5 below) in the `data/` directory as specified in each notebook
2. **Run notebooks in order** (1 → 11 for main analysis)
3. **Run Stata script** (`11_regression_analysis_stata.do`) for final regressions
4. **(Optional)** Run CEO dismissal analysis notebooks in `src_code/ceo dismissal/`

**Note:** Running the full pipeline from scratch will take considerable time and API costs:
- Notebook 3 (promise identification): ~$2,000-3,000 in OpenAI API costs
- Notebooks 5-6 (horizon & specificity): ~$500-1,000
- CEO dismissal follow-up: ~$1,000-1,500

---

## 4. Output data: A database of CEO promises

The main output is a database of **74,017 CEO promises** extracted from 69,302 S&P 1500 earnings-call transcripts (2010–2022). You can download it directly — no coding required:

> **[⬇️ Download CEO_promises_database_2025.csv](data/CEO_promises_database_2025.csv)**

Each row is one promise. The publicly shared CSV contains the following columns:

| Column | Description |
|--------|-------------|
| `gvkey` | Compustat firm identifier |
| `mostimportantdateutc` | Date of the earnings call |
| `companyname` | Company name |
| `exec_fullname` | Name of the CEO who made the promise |
| `transcriptid` | Capital IQ transcript identifier |
| `promise_id` | Unique promise identifier (`gvkey_transcriptid_##`) |
| `promise-horizon-v2` | Estimated number of months until the promised outcome is expected (or `unclear`) |
| `specificity_score` | How specific the promise is, scored 1 (vague) to 5 (very precise) |
| `primary_keyword` | Topic label assigned via keyword extraction and clustering |

**Note on verbatim text:** Because the underlying earnings-call transcripts are proprietary (S&P Global Transcripts via WRDS), the public CSV does **not** include the verbatim promise text (`promise-verbatim`) or the LLM-generated explanation (`promise-explain`). A full version of the database containing these columns is available upon request — see below.

> **Requesting the full database:**  
> Academic researchers whose institution has access to the S&P Global Transcripts database can request the full version (including `promise-verbatim` and `promise-explain`) by emailing **majzoubi@yorku.ca**. Please use your institutional email and confirm that your institution has an active subscription to the S&P Global Transcripts.

**Tip:** The CSV file can be opened directly in Excel, Google Sheets, or any spreadsheet application.

---

## 5. Required proprietary sources (not included)

The following data sources are required but not included due to licensing restrictions:

| Item                                         | Where to get it                | Used in step |
|-----------------------------------------------|-------------------------------|--------------|
| Capital-IQ `wrds_transcript` tables           | WRDS subscription             | 1–2          |
| Compustat (quarterly & annual)                | WRDS subscription             | 10           |
| Execucomp                                     | WRDS subscription             | 2, 10        |
| IBES Summary Statistics                       | WRDS subscription             | 10           |
| Compustat Segments                            | WRDS subscription             | 10           |
| BoardEx "Composition of Officers, Directors…" | BoardEx subscription          | 10           |
| PRisk firm-quarter dataset                    | [policyuncertainty.com](https://policyuncertainty.com) | 10       |
| US EPU index (Baker et al.)                   | [policyuncertainty.com](https://policyuncertainty.com) | 10 |
| Management earnings guidance data             | Contact authors for source    | 10           |
| Loughran-McDonald Master Dictionary (2023)    | [Notre Dame Software Repository](https://sraf.nd.edu/) | 10 |

---

## 6. System requirements

### Computational requirements

- **Memory:** 16GB RAM minimum (32GB recommended for notebook 10)
- **Storage:** ~50GB for raw transcript data + intermediate files


### Software requirements

- **Python:** 3.10 or higher
- **Stata:** Version 17 or higher (SE or MP)
  - Required Stata packages: `reghdfe`, `ppmlhdfe`, `estout`
- **Jupyter:** For running notebooks (included in requirements.txt)

---

## 7. Notes on replication

### API rate limits

- **OpenAI:** The analysis uses concurrent requests (250+ simultaneous). Monitor your rate limits.
- **Anthropic:** Notebook 7 uses Claude-3 Sonnet with lower concurrency requirements.

### Checkpoint/resume functionality

Notebooks 3, 5, and 6 include automatic checkpointing:
- Progress is saved to `.pkl` files every batch (500-1000 records)
- If interrupted, re-running will resume from the last checkpoint
- No need to re-process completed records


---

## 8. Citing this work

If you use any code, data, or materials from this repository, please cite:

> Majzoubi, M., Murray, A., & Mayew, W. J. (2026). Shaping expectations, losing flexibility: A study of CEO promises as strategic communication tools. *Strategic Management Journal*, forthcoming.

---

## 9. Contact

For questions, issues, or data requests, please contact:

- **Majid Majzoubi** — majzoubi@yorku.ca

Or open an issue on this repository's GitHub page.

---

## 10. License

**Code:** © 2025 the authors, released under the MIT License.

**Data:** De-identified promise database released under CC-BY-4.0.

**Note:** Original Capital-IQ, WRDS, BoardEx, and other proprietary data remain subject to their respective licenses and are not included in this repository.

---

*Last updated: February 2026*
