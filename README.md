## SOAL NOMOR 1
Tujuan dari skript bash ini untuk melakukan analisis terhadap data penjualan yang tersimpan dalam file CSV. Skrip ini menggunakan beberapa perintah untuk mengekstrak wawasan berharga dari data penjualan.
## Langkah Langkah
1. **Unduh Data Penjualan**
   - Jika file `Sandbox.csv` belum ada, skrip akan mengunduhnya dari Google Drive menggunakan perintah `wget`.
     Untuk Perintah ini saya menggunakan command berikut:
   ```bash
   if [ ! -f "Sandbox.csv" ]; then
       wget -O Sandbox.csv "https://drive.google.com/uc?export=download&id=1cC6MYBI3wRwDgqlFQE1OQUN83JAreId0"
   fi
2. **Pembeli dengan Penjualan Tertinggi (Perintah A)**
   - Skrip akan menghitung total penjualan untuk setiap pembeli.
   - Kemudian, akan menampilkan nama pembeli dengan penjualan tertinggi.
     Untuk Perintah ini saya menggunakan command berikut:
   ```bash
   echo "A"
   awk -F ',' 'NR>1 {sales[$6]+=$17} END {for (seller in sales) print seller","sales[seller]}' Sandbox.csv | sort -t',' -k2 -nr | head -n 1
3. **Segment Pelanggan dengan Profit Terendah (Perintah B)**
   - Skrip akan menghitung total profit untuk setiap segment pelanggan.
   - Kemudian, akan menampilkan segment pelanggan dengan profit terendah.
     Untuk Perintah ini saya menggunakan command berikut:
    ```bash
    echo "B"
    awk -F ',' 'NR>1 {profit[$7]+=$20} END {for (segment in profit) print segment","profit[segment]}' Sandbox.csv | sort -t',' -k2 -n | head -n 1
4. **3 Kategori dengan Total Profit Tertinggi (Perintah C)**
   - Skrip akan menghitung total profit untuk setiap kategori produk.
   - Kemudian, akan menampilkan 3 kategori dengan total profit tertinggi.
     Untuk Perintah ini saya menggunakan command berikut:
    ```bash
    echo "C"
    awk -F ',' 'NR>1 {profit[$14]+=$20} END {for (category in profit) print category","profit[category]}' Sandbox.csv | sort -t',' -k2 -nr | head -n 3
5. **Pembelian untuk Pelanggan Bernama Adriaens (Perintah D)**
   - Skrip akan menampilkan tanggal pembelian dan jumlah (quantity) untuk pembelian yang dilakukan oleh pelanggan bernama Adriaens.
     Untuk Perintah ini saya menggunakan command berikut:
   ```bash
   echo "D"
   awk -F ',' '$6 ~ /Adriaens/ {print $2","$18}' Sandbox.csv

# SOAL NOMOR 2
### login.sh

1. Fungsi untuk login
```bash
login_user() {
    echo "Enter your email:"
    read email
    echo "Enter password:"
    read -s passwd
    echo

    if grep -q "^$email," users.txt; then
        stored_passwd=$(grep "^$email," users.txt | cut -d',' -f5)
        if [ "$passwd" = "$(echo "$stored_passwd" | base64 --decode)" ]; then
            echo "Login successful!"
            echo "$(date +%Y/%m/%d %h:%m:%s) LOGIN SUCCESS" >> auth.log
            if [[ "$email" == *admin* ]]; then
                admin
            else
                echo "You don't have admin previledge! Welcome!"
            fi
        else
            echo "Wrong email or password."
            echo "$(date +%Y/%m/%d %h:%m:%s) LOGIN FAILED" >> auth.log
        fi
    else
        echo "Wrong email or password."
        echo "$(date +%Y/%m/%d %h:%m:%s) LOGIN FAILED" >> auth.log
    fi
}
```

2. Fungsi untuk menjalankan pilihan lupa password
```bash
forgot() {
    read -p "Email: " email
    if grep -q "^$email," users.txt; then
        sec_q=$(grep "^$email," users.txt | cut -d',' -f3)
        echo "Security Question: $sec_q"
        read -p "Answer: " user_ans
        stored_ans=$(grep "^$email," users.txt | cut -d',' -f4)
        if [ "$user_ans" = "$stored_ans" ]; then
            stored_passwd=$(grep "^$email," users.txt | cut -d',' -f5)
            echo "Your password is: $(echo "$stored_passwd" | base64 --decode)"
        else
            echo "Wrong answer."
        fi
    else
        echo "Email not found."
    fi
}
```
3. Menampilkan menu admin
```bash
admin() {
    echo "Admin Menu"
    echo "1. Add User"
    echo "2. Edit User"
    echo "3. Delete User"
    echo "4. Logout"
    read admin_choice
    case "$admin_choice" in
        "1") source register.sh ;;
        "2") edit_user ;;
        "3") delete_user ;;
        "4") exit ;;
        *) echo "Invalid option" ;;
    esac
}
```

4. Fungsi untuk mengedit user yang terdaftar di user.txt
```bash
edit_user() {
    cat users.txt
    echo "Enter the email of the user you want to edit:"
    read email_edit
    if grep -q "^$email_edit," users.txt; then
        read -p "New Username: " new_username
        read -p "New Security Question: " new_sec_q
        read -p "New Security Answer: " new_sec_a
        read -s -p "New Password: " new_password
        echo
        encrypted_password=$(echo -n "$new_password" | base64)

        sed -i "/^$email_edit,/c\\$email_edit,$new_username,$new_sec_q,$new_sec_a,$encrypted_password" users.txt
        echo "User has been edited!"
    else
        echo "Email not found."
    fi
}
```

5. Fungsi untuk delete user yang terdaftar
```bash
delete_user() {
    cat users.txt
    echo "Enter the email of the user you want to delete:"
    read delete_email
    if grep -q "^$delete_email," users.txt; then
        sed -i "/^$delete_email,/d" users.txt
        echo "User has been deleted"
    else
        echo "Email not found."
    fi
}
```

6. Main Function untuk menjalankan program dan memanggil fungsi-fungsi diatas
```bash
echo "Welcome to Login System"
while true; do
    echo "1. Login"
    echo "2. Forgot Password"
    echo "3. Exit"
    read choice
    case "$choice" in
    "1") login_user ;;
    "2") forgot ;;
    "3") echo "Thank you!"; exit ;;
    *) echo "Invalid option" ;;
    esac
done
```
### register.sh

1. Fungsi untuk mengecek apakah email yang dimasukan sudah dipakai user lainnya atau belum
```bash
unique_email(){
    if grep -q "$1" users.txt; then
        echo "Email already used, please enter a new email"
        return 1
    else
        return 0
    fi
}
```

2. Fungsi untuk mengenkripsi password menjadi base64
```bash
encryption(){
    encrypt=$(echo -n "$1" | base64)
}
```

3. Fungsi utama untuk memanggil fungsi-fungsi diatas dan menjalankan interface registrasi user
```bash 
while true; do
    echo "Welcome to Registration System"
    read -p "Enter your email : " email
    unique_email "$email" || continue
    read -p "Enter your username : " username
    read -p "Enter a security question: " sec_q
    read -p "Enter the answer of your security question: " sec_a
    while true; do
        read -s -p "Enter a password minimum 8 characters, at least 1 uppercase letter, 1 lowercase letter, 1 digit, 1 symbol, and not the same as username, birthdate, or name : " passwd
        echo

        if [[ ${#passwd} -lt 8 || ! "$passwd" =~ [[:upper:]] || ! "$passwd" =~ [[:lower:]] || ! "$passwd" =~ [[:digit:]] || ! "$passwd" =~ [[:punct:]] ]]; then
            echo "Password doesn't meet the requirements, please try again!"
            echo "$(date +%Y/%m/%d %h:%m:%s) REGISTER FAILED" >> auth.log	     
        else 
            break
        fi
    done
```

4. Enkripsi password yang dimaasukan user
```bash
    encryption "$passwd"
```
5. Jika terdapat kata admin dalam email maka role akan berubah menjadi admin
```bash
    if [[ "$email" == *admin* ]]; then
        role="admin"
    else 
        role="user"
    fi
```

6. Memasukan seluruh data kedalam user.txt
```bash
    echo "$email,$username,$sec_q,$sec_a,$encrypt,$role" >> users.txt
    echo "$(date +%Y/%m/%d %h:%m:%s) REGISTER SUCCESS" >> auth.log 
    echo "User registered successfully!"
    break
done
```

## SOAL NOMOR 3

### awal.sh

1. Mendownload file genshin.zip yang berisi genshin_character.zip dan list_character.csv, lalu mengekstrak genshin_character.zip
```bash
wget -O genshin.zip "https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN"
unzip genshin.zip
unzip genshin_character.zip 
```
2. Membuat folder region berdasarkan list_character.csv
```bash
region=$(awk -F "," '{printf ("%s,", $2)}' list_character.csv)
IFS=',' read -r -a listregion <<< "$region"
for ((i=1; i<${#listregion[@]}; i++)); do
  mkdir -p "/home/ubuntu/soal_3/genshin_character/${listregion[i]}"
done
```
3. Membaca file list_character.csv
```bash
IFS=$'\n' read -d '' -a data < <(tail -n +2 list_character.csv)
```
4. Mengdecode nama asli jpg dari hex ke text
```bash
for asli in genshin_character/*; do
  nama1=$(echo "${asli/*\//}")
  nama2=$(printf "%s" "${nama1%.jpg}" | xxd -r -p) 
```

5. Mengubah nama hasil decode dengan format NAMA - REGION - ELEMENT - SENJATA
```bash
  for datachar in "${data[@]}"; do
    datachar2=$(echo "$datachar" | awk -F, '{print $1}')
    if [ "$nama2" = "$datachar2" ]; then
      namabaru=$(echo "$datachar" | awk -F, '{print $1 " - " $2 " - " $3 " - " $4}' | tr -d '\r')
      filebaru="${namabaru}.jpg"
```

6. Memindahkan gambar karakter berdasarkan regionnya ke folder region yang sesuai dengan list_character.sv
```bash
      regionchar=$(echo "$datachar" | awk -F, '{print $2}' | tr -d '\r')
      mv "genshin_character/$nama1" "genshin_character/$regionchar/$filebaru"
    fi
```
  done
done

7. Menghitung jumlah senjata
```bash
awk 'BEGIN {printf "Bow : "} /Bow/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Catalyst : "} /Catalyst/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Claymore : "} /Claymore/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Polearm : "} /Polearm/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Sword : "} /Sword/ { ++n } END {print n}' list_character.csv
```
8. Menghapus file yang tidak diperlukan
```bash
rm list_character.csv 
rm genshin_character.zip
rm genshin.zip
```
### search.sh

1. Akses direktori genshin_character dan set found untuk penanda
```bash
cd genshin_character
found=0
``` 

2. Membuka semua folder region dan mensteghide semua file
```bash
for region in *; do
  if [ -d "$region" ]; then
    for file_jpg in "$region"/*.jpg; do
      if [ -f "$file_jpg" ]; then
        file_basename=$(basename "$file_jpg")
        file_name="${file_basename%.*}"
        steghide extract -sf "$file_jpg" -p "" -xf "$file_name.txt"
```
3. Mendecode hasil steghide setiap file
```bash
        file_steg="$file_name.txt"
        steg_code=$(<"$file_steg")
        steg_res=$(echo -n "$steg_code" | base64 --decode 2>/dev/null)
```
4. Mengecek apakah hasil decode mengandung http
```bash
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
```

5.Jika ditemukan maka menghentikan loop
```bash
  if [ "$found" -eq 1 ]; then  
    break
  fi
done
```

6. Memindahkan file
```bash
mv /home/ubuntu/soal_3/genshin_character/*.{jpg,txt,log} /home/ubuntu/soal_3/
```

## SOAL NOMOR 4

### minute_log.sh

1. Membuat variabel untuk mengambil waktu saat ini dan menentukan path file
```bash
timestamp=$(date +"%Y%m%d%H%M%S")
logfile="/home/ubuntu/log/metrics_${timestamp}.log"
```

2. Monitoring ram
```bash
record_ram() {
    ram_info=$(free -m | awk 'NR==2{print $2","$3","$4","$5","$6","$7}')
    swap_info=$(free -m | awk 'NR==3{print $2","$3","$4}')
    echo -e "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" >> "$logfile" 
    echo -n "$ram_info,$swap_info," >> "$logfile"
}
```

3. Monitoring size directory
```bash
record_directory_size() {
    target_path="/home/ubuntu/"
    path_size=$(du -sh "$target_path" | cut -f1)
    echo -n "$target_path,$path_size" >> "$logfile"
}
```

4. Menjalankan fungsi monitoring
```bash
record_ram
record_directory_size
```

5. Crontab agar file berjalan setiap 1 menit
```bash
#* * * * * /home/ubuntu/soal_4/minute_log.sh
```

###aggregate_minutes_to_hourly_log.sh

1. Membuat variabel untuk mengambil waktu saat ini dan menentukan path file
```bash
timestamp=$(date +"%Y%m%d%H")
logfiles="/home/ubuntu/log/metrics_agg_${timestamp}.log"
```

2. Membuat variabel untuk menyimpan nilai minimum,maksimum, dan total
```bash
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
```

3. Set variabel count untuk menghitung banyak file metrics
```bash
count=0
```

4. Mencari nilai minimum, maksimum, dan total dari semua file metrics
```bash
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
```

5. Menghitung rata-rata 
```bash
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
```

6. Memasukkan hasil ke metrics_agg_${timestamp}.log
```bash
echo -e "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$logfiles"
echo "minimum,$min_mem_total,$min_mem_used,$min_mem_free,$min_mem_shared,$min_mem_buff,$min_mem_available,$min_swap_total,$min_swap_used,$min_swap_free,/home/ubuntu/,$min_path_size" >> "$logfiles"
echo "maximum,$max_mem_total,$max_mem_used,$max_mem_free,$max_mem_shared,$max_mem_buff,$max_mem_available,$max_swap_total,$max_swap_used,$max_swap_free,/home/ubuntu/,$max_path_size" >> "$logfiles"
echo "average,$avg_mem_total,$avg_mem_used,$avg_mem_free,$avg_mem_shared,$avg_mem_buff,$avg_mem_available,$avg_swap_total,$avg_swap_used,$avg_swap_free,/home/ubuntu/,$avg_path_size" >> "$logfiles"
```

7. Crontab agar file berjalan setiap 1 jam
```bash
#0 * * * * /home/ubuntu/soal_4/aggregate_minutes_to_hourly_log.sh
```
