# CS 131 - Shell script to download, extract, and summarize multiple CSV datasets

echo "Enter the URL of the dataset (e.g., from UCI ML Repo):"
read dataset_url

# Make working directory
mkdir -p tmp_data
cd tmp_data || exit

# Download dataset
echo "Downloading..."
wget -q --content-disposition "$dataset_url"

# Rename spaces in filenames
for f in *; do
    mv "$f" "$(echo "$f" | tr ' ' '_')"
done

# Unzip if necessary
for zip in *.zip; do
    [ -f "$zip" ] && unzip -o "$zip" >/dev/null && rm "$zip"
done

# Find all CSV files
csv_files=$(ls *.csv 2>/dev/null)

if [ -z "$csv_files" ]; then
    echo "No CSV files found. Exiting."
    cd ..
    rm -r tmp_data
    exit 1
fi

for csv_file in $csv_files; do
    echo ""
    echo "Processing: $csv_file"

    # Detect delimiter using second line
    second_line=$(head -n 2 "$csv_file" | tail -n 1)

    best_delim=","
    max_fields=0
    for d in ',' ';' '\t' '|' ':'; do
        field_count=$(echo "$second_line" | awk -F"$d" '{print NF}')
        if [ "$field_count" -gt "$max_fields" ]; then
            max_fields=$field_count
            best_delim=$d
        fi
    done

    delim=$best_delim

    # Extract and print header column names
    echo ""
    echo "Feature list for $csv_file:"
    awk -F"$delim" 'NR==1 {
      for (i=1; i<=NF; i++) {
        gsub(/^"|"$/, "", $i);
        print i ". " $i
      }
    }' "$csv_file"

    echo ""
    echo "Enter comma-separated indices of numerical columns for $csv_file (e.g., 1,2,3):"
    read num_indices_raw

    # Prepare clean data file
    tail -n +2 "$csv_file" > "data_only.csv"

    summary_file="../summary_$(basename "$csv_file" .csv).md"
    echo "# Feature Summary for $csv_file" > "$summary_file"
    echo "" >> "$summary_file"
    echo "## Feature Index and Names" >> "$summary_file"

    # Write column names
    awk -F"$delim" 'NR==1 {
      for (i=1; i<=NF; i++) {
        gsub(/^"|"$/, "", $i);
        print i ". " $i
      }
    }' "$csv_file" >> "$summary_file"

    echo "" >> "$summary_file"
    echo "## Statistics (Numerical Features)" >> "$summary_file"
    echo "| Index | Feature           | Min  | Max  | Mean  | StdDev |" >> "$summary_file"
    echo "|-------|-------------------|------|------|-------|--------|" >> "$summary_file"

    # Loop through each column index provided
    for idx in $(echo "$num_indices_raw" | tr ',' ' '); do
        col_name=$(awk -F"$delim" -v col="$idx" 'NR==1 {
            gsub(/^"|"$/, "", $col); print $col
        }' "$csv_file")

        cut -d"$delim" -f"$idx" "data_only.csv" | sed '/^$/d' | sed 's/"//g' > column.tmp

        # Clean numeric values
        grep -E '^[+-]?[0-9]+([.][0-9]+)?$' column.tmp > column_clean.tmp

        min=$(awk 'NR==1{min=$1} $1<min{min=$1} END{print min}' column_clean.tmp)
        max=$(awk 'NR==1{max=$1} $1>max{max=$1} END{print max}' column_clean.tmp)
        mean=$(awk '{sum+=$1} END{if (NR>0) print sum/NR; else print 0}' column_clean.tmp)
        stddev=$(awk -v m="$mean" '{s+=($1-m)^2} END{if (NR>1) print sqrt(s/NR); else print 0}' column_clean.tmp)

        printf "| %5s | %-17s | %.2f | %.2f | %.3f | %.3f |\n" "$idx" "$col_name" "$min" "$max" "$mean" "$stddev" >> "$summary_file"
    done

    echo "Saved summary to $summary_file"
    rm -f column.tmp column_clean.tmp data_only.csv
done

cd ..
rm -r tmp_data
echo ""
echo "All summaries generated."

