# datacollector.sh — CS 131 Assignment 2

## What This Script Does

`datacollector.sh` is a shell script that automates the process of downloading and summarizing **CSV datasets** from a user-provided URL. It supports datasets from the UCI Machine Learning Repository and handles ZIP archives that contain one or more CSV files.

It performs the following tasks:

- Downloads a CSV file or ZIP archive containing CSVs
- Extracts all CSV files from the archive
- Automatically detects the delimiter by checking common options: `,`, `;`, `\t`, `|`, `:`
- Lists the feature (column) names for each CSV
- Prompts the user to identify which columns are numerical
- Calculates **min**, **max**, **mean**, and **standard deviation** for each selected numerical column using `awk`
- Creates a Markdown summary file for each CSV: `summary_<filename>.md`
- Cleans up temporary files after execution

---

## How to Use It

1. Open a terminal and navigate to your script's folder.

2. Run the script with Bash:
   ```bash
   bash datacollector.sh
   ```

3. When prompted:

    * Paste in a URL to a dataset (e.g. https://archive.ics.uci.edu/static/public/186/wine+quality.zip)

    * Review the list of features shown

    * Enter the column numbers (indices) of the numerical columns (e.g. 1,2,3)

4. The script will:

    * Download and extract the ZIP file (if applicable)

    * Detect the delimiter (from common delimiters)

    * List the feature names

    * Prompt you to identify the numeric columns

    * Generate summary.md containing:

        * The feature list

        * A table of min, max, mean, and standard deviation for selected numeric columns

---

## Output Example

```bash
$ bash datacollector.sh
Enter the URL of the dataset (e.g., from UCI ML Repo):
https://archive.ics.uci.edu/static/public/186/wine+quality.zip
Downloading...
mv: 'wine+quality.zip' and 'wine+quality.zip' are the same file

Processing: winequality-red.csv

Feature list for winequality-red.csv:
1. fixed acidity
2. volatile acidity
3. citric acid
4. residual sugar
5. chlorides
6. free sulfur dioxide
7. total sulfur dioxide
8. density
9. pH
10. sulphates
11. alcohol
12. quality

Enter comma-separated indices of numerical columns for winequality-red.csv (e.g., 1,2,3):
1,2,3,4,5,6,7,8,9,10,11,12
Saved summary to ../summary_winequality-red.md

Processing: winequality-white.csv

Feature list for winequality-white.csv:
1. fixed acidity
2. volatile acidity
3. citric acid
4. residual sugar
5. chlorides
6. free sulfur dioxide
7. total sulfur dioxide
8. density
9. pH
10. sulphates
11. alcohol
12. quality

Enter comma-separated indices of numerical columns for winequality-white.csv (e.g., 1,2,3):
1,4,7,9
Saved summary to ../summary_winequality-white.md

All summaries generated.
```
