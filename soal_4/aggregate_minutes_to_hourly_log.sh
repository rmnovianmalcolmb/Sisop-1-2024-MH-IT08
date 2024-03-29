#!/bin/bash

timestamp=$(date +"%Y%m%d%H")
logfiles="/home/ubuntu/log/metrics_agg_${timestamp}.log"

min_mem_total=99999999
max_mem_total=0
min_mem_used=99999999
max_mem_used=0
min_mem_free=99999999
max_mem_free=0
min_mem_shared=99999999
max_mem_shared=0
min_mem_buff=99999999
max_mem_buff=0
min_mem_available=99999999
max_mem_available=0
min_swap_total=99999999
max_swap_total=0
min_swap_used=99999999
max_swap_used=0
min_swap_free=99999999
max_swap_free=0
min_path_size=99999999
max_path_size=0

total_mem_total=0
total_mem_used=0
total_mem_free=0
total_mem_shared=0
total_mem_buff=0
total_mem_available=0
total_swap_total=0
total_swap_used=0
total_swap_free=0
total_path_size=0

count=0

for logfile in /home/ubuntu/log/metrics_*.log; do
    mem_total=$(awk -F',' 'NR==2{print $1}' "$logfile")
    mem_used=$(awk -F',' 'NR==2{print $2}' "$logfile")
    mem_free=$(awk -F',' 'NR==2{print $3}' "$logfile")
    mem_shared=$(awk -F',' 'NR==2{print $4}' "$logfile")
    mem_buff=$(awk -F',' 'NR==2{print $5}' "$logfile")
    mem_available=$(awk -F',' 'NR==2{print $6}' "$logfile")
    swap_total=$(awk -F',' 'NR==2{print $7}' "$logfile")
    swap_used=$(awk -F',' 'NR==2{print $8}' "$logfile")
    swap_free=$(awk -F',' 'NR==2{print $9}' "$logfile")
    path_size=$(awk -F',' 'NR==2{print $11}' "$logfile")

    ((count++))

    if ((mem_total < min_mem_total)); then
        min_mem_total=$mem_total
    fi
    if ((mem_total > max_mem_total)); then
        max_mem_total=$mem_total
    fi
    if ((mem_used < min_mem_used)); then
        min_mem_used=$mem_used
    fi
    if ((mem_used > max_mem_used)); then
        max_mem_used=$mem_used
    fi
    if ((mem_free < min_mem_free)); then
        min_mem_free=$mem_free
    fi
    if ((mem_free > max_mem_free)); then
        max_mem_free=$mem_free
    fi
    if ((mem_shared < min_mem_shared)); then
        min_mem_shared=$mem_shared
    fi
    if ((mem_shared > max_mem_shared)); then
        max_mem_shared=$mem_shared
    fi
    if ((mem_buff < min_mem_buff)); then
        min_mem_buff=$mem_buff
    fi
    if ((mem_buff > max_mem_buff)); then
        max_mem_buff=$mem_buff
    fi
    if ((mem_available < min_mem_available)); then
        min_mem_available=$mem_available
    fi
    if ((mem_available > max_mem_available)); then
        max_mem_available=$mem_available
    fi
    if ((swap_total < min_swap_total)); then
        min_swap_total=$swap_total
    fi
    if ((swap_total > max_swap_total)); then
        max_swap_total=$swap_total
    fi
    if ((swap_used < min_swap_used)); then
        min_swap_used=$swap_used
    fi
    if ((swap_used > max_swap_used)); then
        max_swap_used=$swap_used
    fi
    if ((swap_free < min_swap_free)); then
        min_swap_free=$swap_free
    fi
    if ((swap_free > max_swap_free)); then
        max_swap_free=$swap_free
    fi
    if ((path_size < min_path_size)); then
        min_path_size=$path_size
    fi
    if ((path_size > max_path_size)); then
        max_path_size=$path_size
    fi

    total_mem_total=$((total_mem_total + mem_total))
    total_mem_used=$((total_mem_used + mem_used))
    total_mem_free=$((total_mem_free + mem_free))
    total_mem_shared=$((total_mem_shared + mem_shared))
    total_mem_buff=$((total_mem_buff + mem_buff))
    total_mem_available=$((total_mem_available + mem_available))
    total_swap_total=$((total_swap_total + swap_total))
    total_swap_used=$((total_swap_used + swap_used))
    total_swap_free=$((total_swap_free + swap_free))
    total_path_size=$((total_path_size + path_size))
done

avg_mem_total=$((total_mem_total / count))
avg_mem_used=$((total_mem_used / count))
avg_mem_free=$((total_mem_free / count))
avg_mem_shared=$((total_mem_shared / count))
avg_mem_buff=$((total_mem_buff / count))
avg_mem_available=$((total_mem_available / count))
avg_swap_total=$((total_swap_total / count))
avg_swap_used=$((total_swap_used / count))
avg_swap_free=$((total_swap_free / count))
avg_path_size=$((total_path_size / count))

echo -e "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$logfiles"
echo "minimum,$min_mem_total,$min_mem_used,$min_mem_free,$min_mem_shared,$min_mem_buff,$min_mem_available,$min_swap_total,$min_swap_used,$min_swap_free,/home/ubuntu/,$min_path_size" >> "$logfiles"
echo "maximum,$max_mem_total,$max_mem_used,$max_mem_free,$max_mem_shared,$max_mem_buff,$max_mem_available,$max_swap_total,$max_swap_used,$max_swap_free,/home/ubuntu/,$max_path_size" >> "$logfiles"
echo "average,$avg_mem_total,$avg_mem_used,$avg_mem_free,$avg_mem_shared,$avg_mem_buff,$avg_mem_available,$avg_swap_total,$avg_swap_used,$avg_swap_free,/home/ubuntu/,$avg_path_size" >> "$logfiles"

#0 * * * * /home/ubuntu/soal_4/aggregate_minutes_to_hourly_log.sh
chmod 600 "$logfiles"
