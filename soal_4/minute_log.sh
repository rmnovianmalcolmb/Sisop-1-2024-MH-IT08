#!/bin/bash

timestamp=$(date +"%Y%m%d%H%M%S")
logfile="/home/ubuntu/log/metrics_${timestamp}.log"

record_ram() {
    ram_info=$(free -m | awk 'NR==2{print $2","$3","$4","$5","$6","$7}')
    swap_info=$(free -m | awk 'NR==3{print $2","$3","$4}')
    echo -e "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" >> "$logfile" 
    echo -n "$ram_info,$swap_info," >> "$logfile"
}

record_directory_size() {
    target_path="/home/ubuntu/"
    path_size=$(du -sh "$target_path" | cut -f1)
    echo -n "$target_path,$path_size" >> "$logfile"
}

record_ram
record_directory_size

#* * * * * /home/ubuntu/soal_4/minute_log.sh
chmod 600 "$logfile"
