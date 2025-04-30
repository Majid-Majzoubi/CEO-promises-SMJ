# CEO Promises Analysis – Replication Repository

Supporting material for

**“Shaping Expectations, Losing Flexibility: A Study of CEO Promises as Strategic Communication Tools”**  
<sub>(Submitted to *Strategic Management Journal*)</sub>

[**⬇️ DOWNLOAD CEO Promises Database**](https://github.com/Majid-Majzoubi/ceo_promises_smj/blob/main/data/sxp1500_ceo_promises_2010_2022.xlsx)

---

## 1. What’s in this repo?

This repository contains all code and documentation to:

1. **Download & clean** 69,302 Capital-IQ earnings-call transcripts (S&P 1500, 2010–2022)
2. **Detect, parse, and label** the 74,017 CEO promises used in the paper
3. **Assemble the regression database** and run every model reported in the manuscript

| Notebook / Script                      | Main Task                                                      | Key External Source         |
|---------------------------------------- |--------------------------------------------------------------- |----------------------------|
| **1_download_transcripts.ipynb**        | Pull raw transcripts from WRDS → Capital IQ                    | WRDS credentials           |
| **2_prepare_transcripts.ipynb**         | Limit to S&P1500, keep CEO presentation only                   | –                          |
| **3_find_promises.ipynb**               | Call OpenAI `o3-mini` to identify promises in calls            | OpenAI API                 |
| **4_promise_db_cleanup.ipynb**          | Flatten JSON, remove guidance, etc.                            | –                          |
| **5_promise_horizon_measure.ipynb**     | GPT prompts → months-to-delivery                               | OpenAI                     |
| **6_promise_specificity_measure.ipynb** | GPT-4o scores (1 = vague … 5 = precise)                        | OpenAI                     |
| **7_promise_topic_model.ipynb**         | Keyword extraction (Claude-3 Sonnet) + HDBSCAN + topic labeling| Anthropic API              |
| **8_promise_db_explorations.ipynb**     | Descriptive figures & sanity checks                            | –                          |
| **9_promises_vs_fls.ipynb**             | Compute forward-looking-statement (FLS) ratios, compare w/ promises | NLTK                  |
| **10_add_regression_vars.ipynb**        | Merge Compustat / Execucomp / IBES / PRisk / EPU               | WRDS & public data         |
| **11_regression_analysis_stata.do**     | All tables in the paper (`reghdfe`, `ppmlhdfe`)                | Stata 17 SE                |

---

## 2. Folder layout

```
.
├─ data/                # (empty by default – see §5)
│   └─ gpt_prompts/     # system & user prompt templates
├─ src_code/            # copies of the *.ipynb above (optional)
└─ README.md            # you are here
```

---

## 3. Quick start

```bash
git clone https://github.com/your-handle/ceo-promises.git
cd ceo-promises

conda create -n ceo_promises python=3.10
conda activate ceo_promises

pip install -r requirements.txt   # ≈ 10 min
```

Set **environment variables** (do *not* hard-code in notebooks):

```bash
export WRDS_USERNAME=mywrdsid
export WRDS_PASSWORD=********
export OPENAI_API_KEY=sk-********
export ANTHROPIC_API_KEY=sk-********   # optional – only step 7
```

Place licensed raw data as indicated in the header of each notebook, then run the notebooks in numerical order.

---

## 4. Output data: A database of CEO promises

- [**sxp1500_ceo_promises_2010_2022.xlsx**](https://github.com/Majid-Majzoubi/ceo_promises_smj/blob/main/data/sxp1500_ceo_promises_2010_2022.xlsx)  
  *74,017 promises, with metadata and LLM-based coding*

---

## 5. Required proprietary sources (not included)

| Item                                         | Where to get it                | Used in step |
|-----------------------------------------------|-------------------------------|--------------|
| Capital-IQ `wrds_transcript` tables           | WRDS subscription             | 1–2          |
| Compustat, Execucomp, IBES                    | WRDS                          | 10           |
| BoardEx “Composition of Officers, Directors…” | BoardEx                       | 10           |
| PRisk firm-quarter dataset                    | [policyuncertainty.com](https://policyuncertainty.com) | 10       |
| US EPU index (Baker et al.)                   | [policyuncertainty.com](https://policyuncertainty.com) | 10 |

---

## 6. Citing the dataset

If you use this code or the CEO-promises dataset, please cite both the article and this repository:

> [Full citation to be added upon publication]

---

## 7. Contact

For questions or issues, please contact [Your Name] at [Your Email].

---

**Code © 2025 the authors, released under the MIT License.**  
De-identified data under CC-BY-4.0; original Capital-IQ / WRDS material remains subject to their respective licenses.

---
