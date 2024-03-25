#!/bin/bash

# Mendapatkan waktu saat ini
timestamp=$(date +"%Y%m%d%H%M%S")

# Membuat nama file log dengan path ke /home/ubuntu/soal_4
logfile="/home/ubuntu/log/metrics_${timestamp}.log"

# Fungsi untuk mencatat metrics RAM dan Swap
record_ram() {
    ram_info=$(free -m | awk 'NR==2{print $2","$3","$4","$5","$6","$7}')
    swap_info=$(free -m | awk 'NR==3{print $2","$3","$4}')
    echo -e "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" >> "$logfile" 
    echo -n "$ram_info,$swap_info," >> "$logfile"
}

# Fungsi untuk mencatat metrics ukuran directory
record_directory_size() {
    target_path="/home/ubuntu/"
    path_size=$(du -sh "$target_path" | cut -f1)
    echo -n "$target_path,$path_size" >> "$logfile"
}

# Memanggil kedua fungsi untuk mencatat metrics
record_ram
record_directory_size

#* * * * * /home/ubuntu/soal_4/minute_log.sh
