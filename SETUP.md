# Setup Guide for CEO Promises Analysis

This guide provides detailed instructions for setting up your environment to replicate the analysis.

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/your-handle/ceo-promises.git
cd ceo-promises
```

---

## Step 2: Create Python Environment

### Option A: Using Conda (Recommended)

```bash
# Create new environment
conda create -n ceo_promises python=3.10

# Activate environment
conda activate ceo_promises

# Install requirements
pip install -r requirements.txt
```

### Option B: Using venv

```bash
# Create virtual environment
python3 -m venv venv

# Activate (Mac/Linux)
source venv/bin/activate

# Activate (Windows)
# venv\Scripts\activate

# Install requirements
pip install -r requirements.txt
```

---

## Step 3: Download NLTK Data

Some notebooks require NLTK data files:

```bash
python -m nltk.downloader punkt
python -m nltk.downloader stopwords
```

Or run this in Python:

```python
import nltk
nltk.download('punkt')
nltk.download('stopwords')
```

---

## Step 4: Set Up API Keys

### Create a `.env` file

Create a file named `.env` in the project root:

```bash
# .env file
WRDS_USERNAME=your_wrds_username
WRDS_PASSWORD=your_wrds_password
OPENAI_API_KEY=sk-your-openai-api-key
ANTHROPIC_API_KEY=sk-your-anthropic-api-key
```

**Important:** Never commit this file to git. It's already in `.gitignore`.

### Alternative: Set environment variables directly

**Mac/Linux (bash/zsh):**

```bash
export WRDS_USERNAME="your_wrds_username"
export WRDS_PASSWORD="your_wrds_password"
export OPENAI_API_KEY="sk-your-openai-api-key"
export ANTHROPIC_API_KEY="sk-your-anthropic-api-key"
```

Add to `~/.bashrc` or `~/.zshrc` to make permanent.

**Windows (PowerShell):**

```powershell
$env:WRDS_USERNAME="your_wrds_username"
$env:WRDS_PASSWORD="your_wrds_password"
$env:OPENAI_API_KEY="sk-your-openai-api-key"
$env:ANTHROPIC_API_KEY="sk-your-anthropic-api-key"
```

---

## Step 5: Install Stata Packages

Open Stata and run:

```stata
ssc install reghdfe
ssc install ppmlhdfe
ssc install ftools
ssc install estout
```

---

## Step 6: Create Data Directories

```bash
mkdir -p data/transcripts_raw_v2
mkdir -p data/gpt_prompts
```

---

## Step 7: Download Required Data

### From WRDS (Notebooks 1-2 will do this automatically)
- Capital IQ transcripts
- Compustat (quarterly & annual)
- Execucomp
- IBES

### Manual downloads required:

1. **BoardEx data**: Download "Composition of Officers, Directors..." and place in `data/`
2. **PRisk data**: Download from [policyuncertainty.com](https://policyuncertainty.com) → place in `data/`
3. **EPU Index**: Download from [policyuncertainty.com](https://policyuncertainty.com) → place in `data/`
4. **Loughran-McDonald Dictionary**: Download from [Notre Dame SRAF](https://sraf.nd.edu/) → place in `data/`
5. **Guidance data**: Contact authors or provide your own → place in `data/`

---

## Step 8: Verify Installation

Run this test script to verify everything is installed:

```python
# test_installation.py
import sys
print(f"Python version: {sys.version}")

try:
    import pandas as pd
    print(f"✓ pandas {pd.__version__}")
except ImportError as e:
    print(f"✗ pandas: {e}")

try:
    import numpy as np
    print(f"✓ numpy {np.__version__}")
except ImportError as e:
    print(f"✗ numpy: {e}")

try:
    import wrds
    print(f"✓ wrds installed")
except ImportError as e:
    print(f"✗ wrds: {e}")

try:
    import openai
    print(f"✓ openai {openai.__version__}")
except ImportError as e:
    print(f"✗ openai: {e}")

try:
    import anthropic
    print(f"✓ anthropic installed")
except ImportError as e:
    print(f"✗ anthropic: {e}")

try:
    import nltk
    print(f"✓ nltk {nltk.__version__}")
except ImportError as e:
    print(f"✗ nltk: {e}")

print("\n--- API Keys Check ---")
import os
keys = ['WRDS_USERNAME', 'WRDS_PASSWORD', 'OPENAI_API_KEY', 'ANTHROPIC_API_KEY']
for key in keys:
    if os.getenv(key):
        print(f"✓ {key} is set")
    else:
        print(f"✗ {key} is NOT set")
```

Save as `test_installation.py` and run:

```bash
python test_installation.py
```

---

## Step 9: Run Notebooks

Start Jupyter:

```bash
jupyter notebook
```

Or use JupyterLab:

```bash
jupyter lab
```

Navigate to `src_code/` and run notebooks in order (1 → 11).

---

## Troubleshooting

### WRDS Connection Issues

If you get SSL certificate errors with WRDS:

```python
import ssl
ssl._create_default_https_context = ssl._create_unverified_context
```

### Memory Issues (Notebook 10)

If you run out of memory:
- Close other applications
- Use a machine with 32GB+ RAM
- Process data in smaller chunks (modify notebook accordingly)

### API Rate Limits

If you hit OpenAI rate limits:
- Reduce `CONCURRENT_REQUESTS` in notebooks 3, 5, 6
- Add delays between batches
- Upgrade your OpenAI tier

### Stata Package Installation

If `ssc install` fails:
- Check internet connection
- Try: `net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")`
- Or download packages manually from their repositories

---

## Cost Estimates

Running the full analysis from scratch will incur API costs:

| Step | Estimated Cost | Notes |
|------|---------------|-------|
| Notebook 3 (Promise identification) | $2,000-3,000 | ~70k transcripts with o3-mini |
| Notebook 5 (Horizon measurement) | $300-500 | ~75k promises |
| Notebook 6 (Specificity scoring) | $200-400 | ~75k promises with GPT-4o |
| Notebook 7 (Topic modeling) | $500-800 | Claude-3 Sonnet |
| CEO dismissal follow-up | $1,000-1,500 | GPT-4o + web search |
| **Total** | **$4,000-6,200** | Varies by pricing tier |

**Note:** These costs can be reduced by:
- Using the provided output files instead of re-running LLM analysis
- Sampling a subset of data for testing
- Using cheaper models (though results may differ)

---

## Next Steps

Once setup is complete:
1. Review the README.md for workflow overview
2. Run notebooks in sequence (allow 3-7 days for full pipeline)
3. Monitor API usage and costs
4. Check intermediate outputs after each major step
5. Run Stata regressions after notebook 10 completes

---

## Getting Help

If you encounter issues:
1. Check the troubleshooting section above
2. Review notebook comments and markdown cells
3. Open an issue on the GitHub repository
4. Contact the authors (see README.md)

---

*Last updated: January 2025*

