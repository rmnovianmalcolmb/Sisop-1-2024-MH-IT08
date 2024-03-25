#!/bin/bash

cd genshin_character
found=0 
for region in *; do
  if [ -d "$region" ]; then
    for file_jpg in "$region"/*.jpg; do
      if [ -f "$file_jpg" ]; then
        file_basename=$(basename "$file_jpg")
        file_name="${file_basename%.*}"
        steghide extract -sf "$file_jpg" -p "" -xf "$file_name.txt"

        file_steg="$file_name.txt"
        steg_code=$(<"$file_steg")
        steg_res=$(echo -n "$steg_code" | base64 --decode 2>/dev/null)

        if [[ "$steg_res" == *http* ]]; then
          echo "[$(date '+%d/%m/%y %H:%M:%S')] [FOUND] [/home/ubuntu/soal_3/genshin_character/$region/$file_basename]" >> "image.log"
          cat image.log
          echo "$steg_res" > "$file_steg"
          wget "$steg_res"
          found=1  
          break
        else
          echo "[$(date '+%d/%m/%y %H:%M:%S')] [NOT FOUND] [/home/ubuntu/soal_3/genshin_character/$region/$file_basename]" >> "image.log"
          rm "$file_steg"
        fi
      fi
      sleep 1
    done
  fi

  if [ "$found" -eq 1 ]; then  
    break
  fi
done

mv /home/ubuntu/soal_3/genshin_character/*.{jpg,txt,log} /home/ubuntu/soal_3/
