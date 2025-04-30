**“Shaping Expectations, Losing Flexibility: A Study of CEO Promises as Strategic Communication Tools”**  
(submitted to Strategic Management Journal)

---

## 1.  What is in this repo?

We release all code required to  
1. download ↔ clean 69,302 Capital-IQ earnings-call transcripts (S&P 1500, 2010-2022),  
2. detect, parse and label the 74,017 CEO promises used in the paper,  
3. create the regression panel and run every model reported in the manuscript.

| Notebook / script | Main task | Key external source |
|-------------------|-----------|---------------------|
| **1_download_transcripts.ipynb** | Pull raw transcripts from WRDS → Capital IQ | WRDS credentials |
| **2_prepare_transcripts.ipynb** | Keep CEO presentation only, build SQLite store | – |
| **3_find_promises.ipynb** | Call OpenAI `o3-mini` to flag promise sentences | OpenAI API |
| **4_promise_db_cleanup.ipynb** | Flatten JSON, remove F-guidance etc. | – |
| **5_promise_horizon_measure.ipynb** | GPT prompts → months-to-delivery | OpenAI |
| **6_promise_specificity_measure.ipynb** | GPT-4o scores (1 = vague … 5 = precise) | OpenAI |
| **7_promise_topic_model.ipynb** | Keyword extraction (Claude-3 Sonnet) + HDBSCAN | Anthropic API |
| **8_promise_db_explorations.ipynb** | Descriptive figures & sanity checks | – |
| **9_promises_vs_fls.ipynb** | Compute forward-looking-statement (FLS) ratios | NLTK |
| **10_add_regression_vars.ipynb** | Merge Compustat / Execucomp / IBES / PRisk / EPU | WRDS & public data |
| **11_regression_analysis_stata.do** | All tables in the paper (`reghdfe`, `ppmlhdfe`) | Stata 17 SE |

---

## 2.  Folder layout

```
.
├─ data/                       # empty by default – see § 5
│   ├─ transcripts_raw/…       # Capital-IQ SQLite files
│   ├─ promises_interim/…      # intermediate .pkl / .csv
│   └─ paper_replication_*     # de-identified release (see § 6)
├─ gpt_prompts/                # system & user prompt templates
├─ notebooks/                  # copies of the *.ipynb above (optional)
├─ 11_regression_analysis_stata.do
├─ requirements.txt
└─ README.md                   # you are here
```

---

## 3.  Quick start

```bash
git clone https://github.com/your-handle/ceo-promises.git
cd ceo-promises
conda create -n ceo_promises python=3.10
conda activate ceo_promises
pip install -r requirements.txt      #  ≈ 10 min
```

Set **environment variables** (do *not* hard-code in notebooks):

```
export WRDS_USERNAME=mywrdsid
export WRDS_PASSWORD=********
export OPENAI_API_KEY=sk-********
export ANTHROPIC_API_KEY=sk-********   # optional – only step 7
```

Place licensed raw data as indicated in the header of each notebook, then run the notebooks in numerical order.  
On a 16-core workstation the full pipeline takes ≈ 24 h (majority = LLM calls).  
For a dry run, set `DEBUG = True` in the first cell of each notebook to process 50 firms only (≈ 10 min).

---

## 4.  Output objects created

* `sxp1500_ceo_promises_2010_2022.xlsx` – 74,017 promises with ≥ 30 attributes each  
* `correlation_table_20240624.rtf`, `descriptive_stats_20240624.rtf`, `regression_results_20240624.doc` – tables exactly as submitted  
* Publication-quality figures saved under `figures/`

---

## 5.  Required proprietary sources (not included)

| Item | Where to get it | Used in step |
|------|-----------------|--------------|
| Capital-IQ *wrds_transcript* tables | WRDS subscription | 1–2 |
| Compustat, Execucomp, IBES | WRDS | 10 |
| BoardEx “Composition of Officers, Directors & SM” | BoardEx | 10 |
| PRisk firm-quarter dataset | www.prisk.tech | 10 |
| US EPU index (Baker et al.) | https://policyuncertainty.com | 10 |

Without these you can still reproduce **all analyses** using the processed files provided in § 6.

---

## 6.  De-identified replication package

To accommodate users without WRDS access we deposited the following on Zenodo (DOI TBA):

* `paper_replication_promises.parquet` – promise-level file (no CUSIP / GVKEY)  
* `paper_regression_panel.parquet` – transcript-quarter observations with all variables in Table 3 (firm identifiers masked)  

Download, unzip into `data/`, then start at notebook **9_promises_vs_fls.ipynb** or run the Stata do-file directly.

---

## 7.  Citing the dataset

Please cite both the article and this repository if you use the code or the CEO-promises dataset:

> Arian M., Smith J. (2025) “Shaping Expectations, Losing Flexibility: A Study of CEO Promises as Strategic Communication Tools.” *Working paper*, McGill University.

BibTeX entry in `citation.bib`.

---

## 8.  Contact

*Majid Arian* – majid.arian [at] mail.mcgill.ca  
GitHub issues and pull requests are welcome: https://github.com/your-handle/ceo-promises

---

Code © 2025 the authors, released under the MIT License.  De-identified data under CC-BY-4.0; original Capital-IQ / WRDS material remains subject to their respective licences.
