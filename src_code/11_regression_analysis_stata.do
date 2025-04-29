cd "/Users/majid/Dropbox/Promises/transcripts_wrds/data/"

import delimited "/Users/majid/Dropbox/Promises/transcripts_wrds/data/sxp1500_presentations_ceo_aggregated_regression_vars_v13_cleaned.csv", clear 


* gen new variables
	gen sich1 = int(sich2/10)
	gen financial_sic=(sich1==6)
	gen earnings_surprise_price = earnings_surprise/prccq

	
* Using missed_forecast dummy
	gen miss_forecasts = 0
	replace miss_forecasts = 1 if earnings_surprise_price < 0
	replace miss_forecasts = . if earnings_surprise_price==.

	
* New CEO
	gen new_ceo = 0
	replace new_ceo = 1 if ceo_tenure < 4
	
	
* Limit promise horizon to 3 st above mean
	summarize promises_1_horizon, detail
	local upper_limit = r(mean) + 5 * r(sd)
	replace promises_1_horizon = `upper_limit' if promises_1_horizon > `upper_limit' & !missing(promises_1_horizon)
	summarize promises_1_horizon, detail


* Assigning labels to variables

	* Dependent Variable
	label variable promises_1_count "Number of CEO Promises"
	label variable promises_1_horizon_nan "Proportion of Promises with Vague Horizon"
	label variable promises_1_horizon "Promise Horizon (Months)"
	label variable promises_1_specificity_score "Promise Specificity (1-5)"


	* Independent Variables
	label variable ceo_tenure "CEO Tenure (Years)"
	label variable new_ceo "New CEO (Dummy, First 3 Years)" // New label based on text description
	label variable ceo_gender_dummy "CEO Gender (1=Male)" // Updated label
	label variable miss_forecasts "Missed Forecast (Dummy)"
	label variable earnings_surprise_price "Earnings Surprise" // Updated label
	label variable prisk "Env. Uncertainty (PRisk)" // New label
	label variable trailing_12month_uncertainty_3co "Env. Uncertainty (EPU Index)" // New label - Assuming this is EPU
	label variable uncertainty_ratio "Env. Uncertainty (Uncertainty Words)" // New label - Assuming this is LM ratio
	label variable fin_slack_raw "Slack Resources (Cash/Assets)" // New label

	* Control Variables
	* Firm Size/Scope/Audience
	label variable at_log "Firm Size (Log Assets)" // Updated label
	label variable firm_age "Firm Age" // Updated label
	label variable numest "Analyst Coverage" // Updated label
	* Firm Performance/Financials
	label variable eps "Earnings Per Share"
	label variable earnings_volatility "Earnings Volatility"
	* Firm Strategy/Operations
	label variable rd_f "R&D Intensity" // Updated label
	label variable n_segments "Number of Segments"
	label variable market_share_sich4 "Market Share (SIC4)" // Updated label
	label variable strategy_unique "Strategy Uniqueness"
	label variable mergers "Merger (Log Expenditure)" // New label - Assuming 'mergers' variable name from old global
	* CEO Characteristics
	label variable ceo_total_shares_owned_log "CEO Ownership (Log Shares)" // Updated label
	label variable ceo_dual_dummy "CEO Duality" // Updated label
	* Transcript Characteristics
	label variable positive_ratio "Speech Sentiment (Positive Ratio)" // New label - Assuming 'positive_ratio' variable name
	label variable word_count_total_log "Speech Length (Log Words)" // New label - Assuming 'word_count_total_log' variable name
	* Industry Context
	label variable hhi_sich4 "Industry Concentration (HHI, SIC4)" // New label - Assuming 'hhi_sich4_reverse_ind' variable name
	label variable gr_total_cc "No. Guidance Items"


	* Define Global Macro for Control Variables (ordered logically consistent with text)
	global controls ///
		/* Firm Size/Scope/Audience */ ///
		at_log firm_age numest ///
		/* Firm Performance/Financials */ ///
		eps earnings_volatility ///
		/* Firm Strategy/Operations */ ///
		rd_f n_segments market_share_sich4 strategy_unique mergers ///
		/* CEO Characteristics */ ///
		ceo_total_shares_owned_log ceo_dual_dummy ///
		/* Transcript Characteristics */ ///
		positive_ratio  word_count_total_log  ///
		/* Industry Context */ ///
		hhi_sich4
	


* Main Models
		
	* Regression 1
	reghdfe promises_1_count $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, replace word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
		
	* Regression 2
	reghdfe promises_1_count ceo_tenure $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 3
	reghdfe promises_1_count new_ceo $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 4
	reghdfe promises_1_count ceo_gender_dummy $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

		
	* Regression 5
	reghdfe promises_1_count miss_forecasts $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 6
	reghdfe promises_1_count earnings_surprise_price $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 7
	reghdfe promises_1_count prisk $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 8
	reghdfe promises_1_count trailing_12month_uncertainty_3co $controls if !financial_sic, a(gvkey  sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	
	* Regression 9
	reghdfe promises_1_count uncertainty_ratio $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 10
	reghdfe promises_1_count fin_slack_raw $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	
	* Regression 11
	reghdfe promises_1_count ceo_tenure ceo_gender_dummy miss_forecasts prisk fin_slack_raw $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	outreg2 using regression_results_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)


	
* Count unique gvkeys in the estimation sample
distinct gvkey if e(sample)
	

* Correlation matrix
reghdfe promises_1_count ceo_tenure ceo_gender_dummy miss_forecasts prisk fin_slack_raw $controls if !financial_sic, a(gvkey year sich2) vce(robust)

* Correlation matrix using the exact same sample as Regression 11
* Use "if e(sample)" to restrict to the sample used by the preceding reghdfe
estpost correlate promises_1_count promises_1_horizon_nan promises_1_horizon promises_1_specificity_score ///
                  ceo_tenure ceo_gender_dummy miss_forecasts earnings_surprise_price ///
                  prisk trailing_12month_uncertainty_3co uncertainty_ratio fin_slack_raw ///
                  $controls if e(sample), matrix listwise

* Exporting the correlation results
esttab using correlation_table_20250429.rtf, replace nostar unstack not noobs compress label nostar numbers b(2)





reghdfe promises_1_count ceo_tenure ceo_gender_dummy miss_forecasts prisk fin_slack_raw $controls if !financial_sic, a(gvkey year sich2) vce(robust)

* Descriptive statistics using the exact same sample as Regression 11
* Use "if e(sample)" to restrict to the sample used by the preceding reghdfe
estpost summarize promises_1_count promises_1_horizon_nan promises_1_horizon promises_1_specificity_score ///
                    ceo_tenure ceo_gender_dummy miss_forecasts earnings_surprise_price ///
                    prisk trailing_12month_uncertainty_3co uncertainty_ratio fin_slack_raw ///
                    $controls if e(sample), detail

* Export the descriptive statistics table
esttab using descriptives_table_20250429.rtf, replace cells("mean sd min max") label compress








* VIF Check for the Full Model (Regression 11)

	* 1. Run standard OLS with the same variables and sample (NO fixed effects)
	regress promises_1_count ceo_tenure ceo_gender_dummy miss_forecasts prisk fin_slack_raw $controls if !financial_sic

	* 2. Calculate VIF
	estat vif

	
	
	


* Horizon and Specificity Analysis



	gen covid_turmoil = ((year == 2020 & month_1month_lag >= 3) | (year == 2021 & month_1month_lag <= 9))
	label variable covid_turmoil "COVID-19 Period (Dummy)"
	

	reghdfe promises_1_count covid_turmoil  $controls if !financial_sic, a(gvkey sich2) vce(robust)
	outreg2 using regression_results_horizon_20250429.doc, replace word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	
	reghdfe promises_1_horizon_nan covid_turmoil promises_1_count $controls if !financial_sic, a(gvkey sich2) vce(robust)
	outreg2 using regression_results_horizon_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	reghdfe promises_1_horizon covid_turmoil promises_1_count $controls if !financial_sic, a(gvkey sich2) vce(robust)
	outreg2 using regression_results_horizon_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
		
	reghdfe promises_1_specificity_score covid_turmoil promises_1_count $controls if !financial_sic, a(gvkey sich2) vce(robust)
	outreg2 using regression_results_horizon_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	

	reghdfe promises_1_horizon_nan prisk promises_1_count $controls if !financial_sic, a(gvkey sich2 year) vce(robust)
	outreg2 using regression_results_horizon_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	
	reghdfe promises_1_horizon prisk promises_1_count $controls if !financial_sic, a(gvkey sich2 year) vce(robust)
	outreg2 using regression_results_horizon_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	
	reghdfe promises_1_specificity_score prisk promises_1_count $controls if !financial_sic, a(gvkey sich2 year) vce(robust)
	outreg2 using regression_results_horizon_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	reghdfe promises_1_horizon_nan trailing_12month_uncertainty_3co promises_1_count $controls if !financial_sic, a(gvkey sich2 ) vce(robust)
	outreg2 using regression_results_horizon_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	
	reghdfe promises_1_horizon trailing_12month_uncertainty_3co promises_1_count $controls if !financial_sic, a(gvkey sich2 ) vce(robust)
	outreg2 using regression_results_horizon_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	
	reghdfe promises_1_specificity_score trailing_12month_uncertainty_3co promises_1_count $controls if !financial_sic, a(gvkey sich2 ) vce(robust)
	outreg2 using regression_results_horizon_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	

	
** Spline Earnings Surprise
	gen neg_earnings_surprise_price = earnings_surprise_price if earnings_surprise_price < 0
	replace neg_earnings_surprise_price = 0 if neg_earnings_surprise_price == .
	gen pos_earnings_surprise_price = earnings_surprise_price if earnings_surprise_price >= 0
	replace pos_earnings_surprise_price = 0 if pos_earnings_surprise_price == .
	
	
	gen neg_earnings_surprise_price_sq = neg_earnings_surprise_price^2
	gen neg_earnings_surprise_price_log = log(neg_earnings_surprise_price*-1)
	
	reghdfe promises_1_count pos_earnings_surprise_price neg_earnings_surprise_price  $controls if !financial_sic, a(gvkey year sich2) vce(robust)
	reghdfe promises_1_count pos_earnings_surprise_price $controls if !financial_sic, a(gvkey year sich2) vce(robust)

	
	

* Removing Firm FE
	* Regression 1
	reghdfe promises_1_count $controls if !financial_sic, a( year sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, replace word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
		
	* Regression 2
	reghdfe promises_1_count ceo_tenure $controls if !financial_sic, a( year sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 3
	reghdfe promises_1_count new_ceo $controls if !financial_sic, a( year sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 4
	reghdfe promises_1_count ceo_gender_dummy $controls if !financial_sic, a( year sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

		
	* Regression 5
	reghdfe promises_1_count miss_forecasts $controls if !financial_sic, a( year sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 6
	reghdfe promises_1_count earnings_surprise_price $controls if !financial_sic, a( year sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 7
	reghdfe promises_1_count prisk $controls if !financial_sic, a( year sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 8
	reghdfe promises_1_count trailing_12month_uncertainty_3co $controls if !financial_sic, a(  sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	
	* Regression 9
	reghdfe promises_1_count uncertainty_ratio $controls if !financial_sic, a( year sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 10
	reghdfe promises_1_count fin_slack_raw $controls if !financial_sic, a( year sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	
	* Regression 11
	reghdfe promises_1_count ceo_tenure ceo_gender_dummy miss_forecasts prisk fin_slack_raw $controls if !financial_sic, a( year sich2) vce(robust)
	outreg2 using regression_results_nofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)



* CEO FE
	* Regression 1
	reghdfe promises_1_count $controls if !financial_sic, a(execid year sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, replace word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
		
	* Regression 2
	reghdfe promises_1_count ceo_tenure $controls if !financial_sic, a(execid year sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 3
	reghdfe promises_1_count new_ceo $controls if !financial_sic, a(execid year sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 4
	reghdfe promises_1_count ceo_gender_dummy $controls if !financial_sic, a(execid year sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

		
	* Regression 5
	reghdfe promises_1_count miss_forecasts $controls if !financial_sic, a(execid year sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 6
	reghdfe promises_1_count earnings_surprise_price $controls if !financial_sic, a(execid year sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 7
	reghdfe promises_1_count prisk $controls if !financial_sic, a(execid year sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 8
	reghdfe promises_1_count trailing_12month_uncertainty_3co $controls if !financial_sic, a(execid  sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	
	* Regression 9
	reghdfe promises_1_count uncertainty_ratio $controls if !financial_sic, a(execid year sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	* Regression 10
	reghdfe promises_1_count fin_slack_raw $controls if !financial_sic, a(execid year sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)
	
	* Regression 11
	reghdfe promises_1_count ceo_tenure ceo_gender_dummy miss_forecasts prisk fin_slack_raw $controls if !financial_sic, a(execid year sich2) vce(robust)
	outreg2 using regression_results_ceofe_20250429.doc, append word label dec(3) stats(coef se pval)  noaster paren(se) bracket(pval)

	
	


*-----------------------------------------------------
* Poisson Regression using ppmlhdfe
*-----------------------------------------------------


	* Regression 1
	ppmlhdfe promises_1_count $controls if !financial_sic, absorb(gvkey year sich2) vce(robust)
	outreg2 using regression_results_poisson_20250429.doc, replace word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)

	* Regression 2
	ppmlhdfe promises_1_count ceo_tenure $controls if !financial_sic, absorb(gvkey year sich2) vce(robust)
	outreg2 using regression_results_poisson_20250429.doc, append word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)

	* Regression 3
	ppmlhdfe promises_1_count new_ceo $controls if !financial_sic, absorb(gvkey year sich2) vce(robust)
	outreg2 using regression_results_poisson_20250429.doc, append word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)

	* Regression 4
	ppmlhdfe promises_1_count ceo_gender_dummy $controls if !financial_sic, absorb(gvkey year sich2) vce(robust)
	outreg2 using regression_results_poisson_20250429.doc, append word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)

	* Regression 5
	ppmlhdfe promises_1_count miss_forecasts $controls if !financial_sic, absorb(gvkey year sich2) vce(robust)
	outreg2 using regression_results_poisson_20250429.doc, append word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)

	* Regression 6
	ppmlhdfe promises_1_count earnings_surprise_price $controls if !financial_sic, absorb(gvkey year sich2) vce(robust)
	outreg2 using regression_results_poisson_20250429.doc, append word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)

	* Regression 7
	ppmlhdfe promises_1_count prisk $controls if !financial_sic, absorb(gvkey year sich2) vce(robust)
	outreg2 using regression_results_poisson_20250429.doc, append word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)

	* Regression 8 - Note different fixed effects
	ppmlhdfe promises_1_count trailing_12month_uncertainty_3co $controls if !financial_sic, absorb(gvkey sich2) vce(robust) // Absorbing gvkey and sich2 only
	outreg2 using regression_results_poisson_20250429.doc, append word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)

	* Regression 9
	ppmlhdfe promises_1_count uncertainty_ratio $controls if !financial_sic, absorb(gvkey year sich2) vce(robust)
	outreg2 using regression_results_poisson_20250429.doc, append word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)

	* Regression 10
	ppmlhdfe promises_1_count fin_slack_raw $controls if !financial_sic, absorb(gvkey year sich2) vce(robust)
	outreg2 using regression_results_poisson_20250429.doc, append word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)

	* Regression 11 - Full Model
	ppmlhdfe promises_1_count ceo_tenure ceo_gender_dummy miss_forecasts prisk fin_slack_raw $controls if !financial_sic, absorb(gvkey year sich2) vce(robust)
	outreg2 using regression_results_poisson_20250429.doc, append word label dec(3) stats(coef se pval) noaster paren(se) bracket(pval)
		
