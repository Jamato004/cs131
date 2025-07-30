#!/bin/bash

FILE="co2.csv"

# Display all the features of the dataset
echo "=== Column Names ==="
head -n 1 "$FILE" | sed  's/,/\n/g' 
echo

# Count the number of entries 
echo "=== Total Entries ==="
tail -n +2 "$FILE" | wc -l
echo

# Display majority vehicle classes (only the first 10 of sorted data)
echo "=== Unique Vehicle Classes ==="
cut -d',' -f3 "$FILE" | tail -n +2 | sort | uniq -c | sort -nr | head -10
echo

# Extract the top ten vehicle classes (only the first 10 of sorted data)
echo "=== Unique Vehicle Classes ==="
echo "=== Top 10 Makes ==="
cut -d',' -f1 "$FILE" | tail -n +2 | sort | uniq -c | sort -nr | head -10
echo

# Calculate the average CO2 emission by employing awk
echo "=== Average CO2 Emissions (g/km) ==="
awk -F',' 'NR>1 {sum+=$NF; count++} END {print sum/count}' "$FILE"
echo

# Compute the statistics for engine size by utilizing awk
echo "=== Engine Size Stats (Liters) ==="
awk -F',' 'NR>1 {sum+=$4; min=($4<min||NR==2)?$4:min; max=($4>max)?$4:max} END {print "Mean:",sum/(NR-1),"\nMin:",min,"\nMax:",max}' "$FILE"
echo

# Calculates the statistics for fuel consumption in city driving by using awk
echo "=== Fuel Consumption City Stats (L/100 km) ==="
awk -F',' 'NR>1 {sum+=$8; min=($8<min||NR==2)?$8:min; max=($8>max)?$8:max} END {print "Mean:",sum/(NR-1),"\nMin:",min,"\nMax:",max}' "$FILE"
echo