#!/bin/bash

wget -O genshin.zip "https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN"
unzip genshin.zip
unzip genshin_character.zip 

region=$(awk -F "," '{printf ("%s,", $2)}' list_character.csv)
IFS=',' read -r -a listregion <<< "$region"
for ((i=1; i<${#listregion[@]}; i++)); do
  mkdir -p "/home/ubuntu/soal_3/genshin_character/${listregion[i]}"
done

IFS=$'\n' read -d '' -a data < <(tail -n +2 list_character.csv)

for asli in genshin_character/*; do
  nama1=$(echo "${asli/*\//}")
  nama2=$(printf "%s" "${nama1%.jpg}" | xxd -r -p) 

  for datachar in "${data[@]}"; do
    datachar2=$(echo "$datachar" | awk -F, '{print $1}')
    if [ "$nama2" = "$datachar2" ]; then
      namabaru=$(echo "$datachar" | awk -F, '{print $2 " - " $1 " - " $3 " - " $4}' | tr -d '\r')
      filebaru="${namabaru}.jpg"

      regionchar=$(echo "$datachar" | awk -F, '{print $2}' | tr -d '\r')
      mv "genshin_character/$nama1" "genshin_character/$regionchar/$filebaru"
    fi
  done
done

awk 'BEGIN {printf "Bow : "} /Bow/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Catalyst : "} /Catalyst/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Claymore : "} /Claymore/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Polearm : "} /Polearm/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Sword : "} /Sword/ { ++n } END {print n}' list_character.csv

rm list_character.csv 
rm genshin_character.zip
rm genshin.zip
