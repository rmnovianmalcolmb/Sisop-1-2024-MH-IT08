#!/bin/bash

if [ ! -f "Sandbox.csv" ]; then
    wget -O Sandbox.csv "https://drive.google.com/uc?export=download&id=1cC6MYBI3wRwDgqlFQE1OQUN83JAreId0"
fi

# Command 1: Menampilkan nama pembeli dengan sales paling tinggi
echo "A"
awk -F ',' 'NR>1 {sales[$6]+=$17} END {for (seller in sales) print seller","sales[seller]}' Sandbox.csv | sort -t',' -k2 -nr | head -n 1
echo ""
# Command 2: Menampilkan Costumer Segment dengan profit paling kecil
echo "B"
awk -F ',' 'NR>1 {profit[$7]+=$20} END {for (segment in profit) print segment","profit[segment]}' Sandbox.csv | sort -t',' -k2 -n | head -n 1
echo ""
# Command 3: Menampilkan 3 Kategori dengan total profit paling tinggi
echo "C"
awk -F ',' 'NR>1 {profit[$14]+=$20} END {for (category in profit) print category","profit[category]}' Sandbox.csv | sort -t',' -k2 -nr | head -n 3
echo ""
# Command 4: Menampilkan purchase date dan amount (quantity) dari nama adriaens
echo "D"
awk -F ',' '$6 ~ /Adriaens/ {print $2","$18}' Sandbox.csv
