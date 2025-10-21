#!/usr/bin/env python3
"""
Installation Test Script for CEO Promises Analysis
Verifies that all required packages and API keys are properly configured.
"""

import sys
import os

def test_package(package_name, import_name=None, version_attr='__version__'):
    """Test if a package is installed and print its version."""
    if import_name is None:
        import_name = package_name
    
    try:
        module = __import__(import_name)
        version = getattr(module, version_attr, 'unknown version')
        print(f"✓ {package_name:20s} {version}")
        return True
    except ImportError as e:
        print(f"✗ {package_name:20s} NOT INSTALLED - {e}")
        return False

def test_api_key(key_name):
    """Test if an API key is set."""
    value = os.getenv(key_name)
    if value:
        masked = value[:8] + "..." if len(value) > 8 else "***"
        print(f"✓ {key_name:25s} {masked}")
        return True
    else:
        print(f"✗ {key_name:25s} NOT SET")
        return False

def main():
    print("=" * 70)
    print("CEO Promises Analysis - Installation Verification")
    print("=" * 70)
    
    # Python version
    print(f"\nPython version: {sys.version}\n")
    
    # Core packages
    print("=" * 70)
    print("CORE PACKAGES")
    print("=" * 70)
    
    core_packages = [
        'pandas',
        'numpy',
        'scipy',
        'matplotlib',
        'seaborn',
    ]
    
    core_ok = all(test_package(pkg) for pkg in core_packages)
    
    # Data access
    print("\n" + "=" * 70)
    print("DATA ACCESS")
    print("=" * 70)
    
    data_ok = test_package('wrds')
    
    # LLM APIs
    print("\n" + "=" * 70)
    print("LLM APIs")
    print("=" * 70)
    
    llm_packages = [
        'openai',
        'anthropic',
    ]
    
    llm_ok = all(test_package(pkg) for pkg in llm_packages)
    
    # NLP packages
    print("\n" + "=" * 70)
    print("NLP & TEXT PROCESSING")
    print("=" * 70)
    
    nlp_packages = [
        ('thefuzz', 'thefuzz'),
        ('python-Levenshtein', 'Levenshtein'),
        ('nltk', 'nltk'),
    ]
    
    nlp_ok = all(test_package(name, imp) for name, imp in nlp_packages)
    
    # ML packages
    print("\n" + "=" * 70)
    print("MACHINE LEARNING")
    print("=" * 70)
    
    ml_packages = [
        ('scikit-learn', 'sklearn'),
        ('hdbscan', 'hdbscan'),
    ]
    
    ml_ok = all(test_package(name, imp) for name, imp in ml_packages)
    
    # Utilities
    print("\n" + "=" * 70)
    print("UTILITIES")
    print("=" * 70)
    
    util_packages = [
        'tenacity',
        'nest_asyncio',
        'tqdm',
        'python-dotenv' ,
        'openpyxl',
        'requests',
    ]
    
    # Handle packages with different import names
    util_tests = [
        test_package('tenacity'),
        test_package('nest_asyncio'),
        test_package('tqdm'),
        test_package('python-dotenv', 'dotenv'),
        test_package('openpyxl'),
        test_package('requests'),
    ]
    util_ok = all(util_tests)
    
    # Jupyter
    print("\n" + "=" * 70)
    print("JUPYTER ENVIRONMENT")
    print("=" * 70)
    
    jupyter_packages = [
        ('jupyter', 'jupyter_core'),
        ('notebook', 'notebook'),
        ('ipykernel', 'ipykernel'),
    ]
    
    jupyter_ok = all(test_package(name, imp) for name, imp in jupyter_packages)
    
    # API Keys
    print("\n" + "=" * 70)
    print("API KEYS & CREDENTIALS")
    print("=" * 70)
    
    api_keys = [
        'WRDS_USERNAME',
        'WRDS_PASSWORD',
        'OPENAI_API_KEY',
        'ANTHROPIC_API_KEY',
    ]
    
    keys_ok = all(test_api_key(key) for key in api_keys)
    
    # Summary
    print("\n" + "=" * 70)
    print("SUMMARY")
    print("=" * 70)
    
    all_ok = core_ok and data_ok and llm_ok and nlp_ok and ml_ok and util_ok and jupyter_ok
    
    if all_ok:
        print("✓ All required packages are installed!")
    else:
        print("✗ Some packages are missing. Install with: pip install -r requirements.txt")
    
    if keys_ok:
        print("✓ All API keys are configured!")
    else:
        print("✗ Some API keys are missing. Set them in .env file or as environment variables.")
    
    print("\n" + "=" * 70)
    
    if all_ok and keys_ok:
        print("SUCCESS! Your environment is ready to run the analysis.")
        return 0
    else:
        print("INCOMPLETE SETUP - Please fix the issues above before running notebooks.")
        return 1

if __name__ == "__main__":
    sys.exit(main())

