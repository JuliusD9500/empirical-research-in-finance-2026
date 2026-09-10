Dr. Beatriz Mariano – Summer 2026

Empirical Research in Finance (English) Assignment

Summer Semester 2026

Part I (80%): Empirical Assignment – group submission

Write a research report that examines the relationship between firm valuation, measured by the book-
to-market ratio, and one-year ahead excess stock returns based on the tasks and instructions described
below. You may conduct the empirical work using R, STATA or Python. The dataset is available on Moodle¹
and consists of two files: an annual firm-year panel of publicly traded German firms
(value_effect_panel.dta) and an abnormal returns file around the event date used in task (h)
(cars_summary.dta).

You are required to construct the following explanatory variables from the raw items (do not copy these
definitions into the report unless they are important for the discussion of your results).

1. book-to-market: book value of equity divided by market value of equity;

2. leverage: sum of "long-term debt" and "debt in current liabilities" all divided by total assets;

3. profitability: EBITDA divided by total assets;

4. dividend yield: dividends per share divided by end-of-year share price;

5. size: natural logarithm of market capitalisation.

Apply the most used filters in finance research, clean and adjust the data as needed, and construct your
final sample. All subsequent analyses must be based on this final sample. Note that some questions build
on earlier results. References to the "previous regression specification/model" always mean the most
recently estimated model, unless stated otherwise.

(a) Compute the mean, standard deviation, minimum, 10th percentile, median, 90th percentile and
maximum for the excess return and for the five variables you constructed above (1–5), and for market
capitalisation. Clearly indicate the unit of measurement for each variable. Report the number of
observations and the number of firms in the final dataset. Assess whether the observed ranges are
economically reasonable and explain your reasoning. If additional filters are applied, clearly justify and
describe them. Present only one final descriptive statistics table, based on the fully filtered sample.

¹ The dataset has been simulated for the purposes of this assignment and does not contain real firm-level financial data.


Dr. Beatriz Mariano – Summer 2026

(b) Estimate a pooled OLS regression of excess return (dependent variable) on book-to-market. Assess
whether the estimated coefficient on book-to-market is statistically different from zero.

(c) Augment the baseline regression by including size, leverage, profitability and dividend yield. Write
down the full econometric model. Given the results, discuss whether these variables are statistically
important.

(d) Create a "small firm" dummy variable, equal to 1 if a firm’s market capitalisation is below the sample
median, and 0 otherwise. Using the model from part (c), exclude size and include the small-firm dummy.
Write down a new econometric model that allows the relationship between excess return and book-to-
market to differ by firm size (as measured by the dummy). Clearly: (i) state the null and alternative
hypotheses, (ii) show on a small table the number of "small firm" observations each year, (iii) estimate
the model, and (iv) test whether the relationship between excess return and book-to-market differs
between large and small firms. Report the relevant test statistic and p-value in the text and discuss the
results from a statistical and economic intuition perspective.

(e) Using the model from part (d), test whether excess return and book-to-market are unrelated. Clearly:
(i) state the null and alternative hypotheses in terms of the relevant model coefficient(s), and (ii) test the
null hypothesis that there is no relationship between excess return and book-to-market. Report the
relevant F-test statistic and p-value, and discuss the results. If any additional calculations are required,
include the relevant code in the Appendix, using only methods covered in the course. Compare your
findings with those obtained in part (c) and comment on any differences.

(f) Extend the previous model by including year dummies and industry dummies based on 2-digit SIC
codes. Write down the updated econometric specification. Explain what these dummy variables capture
econometrically and discuss how the results differ from those in part (d). Based on your results, evaluate
whether this updated model provides a better overall specification than the previous one. Do not report
individual coefficients for the year or industry dummies in the regression table.

(g) Building on the previous model, compute heteroskedasticity-robust standard errors clustered by firm.
Include this regression as an additional column in your results table. Discuss whether coefficient estimates
change meaningfully. Interpret the sign, statistical significance, and economic magnitude of the
profitability coefficient. Provide a numerical economic interpretation and show the calculation directly in
the text.


Dr. Beatriz Mariano – Summer 2026

(h) On 23 June 2016 the United Kingdom held a referendum and voted to leave the European Union. The
result was announced in the early hours of 24 June 2016 and was widely interpreted as a shock for German
firms with significant exposure to the UK. The dataset records UK exposure in two ways: through UK sales
and through UK listing status. Answer the following and include your code in the Appendix.

1. Event design. State the event date in calendar time; and the calendar trading days for the event
   windows [-1,+1] and [-2,+2].

2. Sample composition. Report the number of treated and control firms under each definition.
   Cross-tabulate both definitions and report how many firms are classified differently across the
   two definitions. Report your results in one small table.

3. Statistical tests. Using the UK sales exposure dummy and the pre-computed parameters given
   in the data files, compute the standard statistical tests used to evaluate the stock market reaction
   on the event date and over each event window in (1) for treated and control group separately,
   and for the difference between groups.² Report, for each event window and each group (treated,
   control, and their difference), the (cumulative) abnormal return (AR/CAR), their standard error or
   t-statistic, and significance stars — all in one compact table.

4. Robustness check. Repeat using the UK listing status dummy. Compare magnitudes and
   significance levels. (3)

5. Discussion. Which definition better captures exposure to the Brexit shock, and why? Does the
   event-study conclusion depend on the treatment definition? Explain in terms of what each
   variable measures.

Use the results from all tasks to write, together with your team, a single, cohesive research report. All
tables should be included within the main text immediately after they are first referenced in the text. All
regression results must be presented in one consolidated table, formatted in the style of an academic
journal article. The text specifications are:

• 1.5 or double-spacing, minimum font size of 11pt (Arial or Calibri), minimum margins of 2.5 cm
  (all sides),

• a maximum of 6 pages (excluding Appendix).

² For the treated-minus-control difference, treat the two groups as independent: add their CAR variances and take the square
root — SE_diff = √(SE²_treated + SE²_control) — then form t = (CAR_treated − CAR_control) / SE_diff.


Dr. Beatriz Mariano – Summer 2026

The report should follow exactly the order and format outlined below. The numbers in parentheses
indicate approximate percentage weights towards the final grade. Use the names in bold as title sections.

• Title, group composition (names and student numbers).

• Abstract: Briefly describe the purpose of the study and summarise the main findings in three to
  four concise sentences. (5%, combined with Conclusion)

• Data: Describe the dataset, including the data type, country, time period, data source, and all
  filters applied (task a). (10%)

• Methodology and Results: Describe the empirical methodology and present results for tasks (b)
  through (g). Include regression models only when explicitly requested. (50%)

• Event Study: Present the results for task (h). (10%)

• Conclusion: Summarise the main findings. (5%, together with Abstract)

• Appendix: include all code, clearly labeled by task. The code must be clean, well-organised, and
  fully reproducible.

• References: Do not use references.


Part II (20%): Mini Research Proposal – individual submission

Suppose that between 26 and 30 September 2024 Hurricane Helene caused significant flooding and wind
damage across parts of the southeastern United States, while other regions of the country were
unaffected. Choose one type of firm-level investment (e.g., capital expenditures (capex), research and
development (R&D), acquisition activity (M&As), etc) and write a research proposal that uses this setting
to examine how this weather shock can influence that type of investment at a firm level. The proposal
must not exceed 3 pages (excluding Appendix) and must follow the same formatting requirements
specified above. It should be structured using the following sections:

• Title

• Background (approximately ½ page): Provide the necessary context for this topic (one to three
  concise sentences), summarise the context and key findings from existing research using one
  reference of your choice, and state the research question in a precise and concise manner.


Dr. Beatriz Mariano – Summer 2026

• Expected Outcome (approximately ¼ page): Clearly state the main hypothesis. Briefly explain the
  economic rationale(s) behind this hypothesis. When appropriate, you may draw on your reference
  to help formulate the hypothesis, but your reasoning does not need to be limited to it.

• Data (approximately ½ page): Describe the data to be used, including the time period, key
  variables, and data sources. Be specific and as precise as possible. Whenever possible, refer to
  databases discussed in class.

• Methodology (approximately ½ page): Present the empirical strategy – write a precise regression
  model. Restrict your answer to methodologies discussed in class. Clearly explain how the research
  question will be tested using this regression model.

• Extensions and Limitations (approximately ¼ to ½ page): Discuss one potential limitation of the
  proposed study and suggest one extension that could strengthen or broaden the analysis. You
  may choose any reasonable limitation and extension, but if your suggestions are methodological,
  make sure they are limited to the empirical methods covered in class.

• Reference: Include one academic reference from the list of recommended journals provided in
  class, cited using an appropriate academic citation style. Provide the full citation and an electronic
  link to the article. Do not use more than one reference – choose the most relevant one if you find
  several options.

• Appendix: You may use AI assistance for this part of the assignment. If you do so, you must include
  in this Appendix a complete record of all prompts used, including those where you disagreed with
  the AI-generated output or requested further clarification or additional explanations.


===

IMPORTANT: Presentation quality is a key component of the overall assessment and may affect the final
grade (approximately 10% of the above allocations). Ensure that ideas are clearly separated into well-
structured paragraphs, avoid repetition and unnecessary discussion, and write in a manner that is clear,
concise, and precise.


Dr. Beatriz Mariano – Summer 2026

DEADLINE AND SUBMISSION: The final report must be submitted via Moodle by 15 September 2026 at
11:00 PM. Each student is required to submit one PDF file containing both individual and group
components. The group submission must be identical across all team members. The uploaded file must
be named "surname_student number".

Good luck!