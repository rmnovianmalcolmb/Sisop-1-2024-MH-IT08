## SOAL NOMOR 1

Tujuan dari script bash ini untuk melakukan analisis terhadap data penjualan yang tersimpan dalam file CSV. Skrip ini menggunakan beberapa perintah untuk mengekstrak wawasan berharga dari data penjualan.

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
4. **Kategori dengan Total Profit Tertinggi (Perintah C)**
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

Untuk output yang akan keluar setelah file soal1.sh dijalankan akan seperti ini:

![Screenshot 2024-03-29 112651](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/150356339/246198db-aff6-45c3-adc5-7f29580518e3)

## SOAL NOMOR 2
Tujuan dari soal ini adalah menciptakan sebuah user interface login system dan registration system yang terintegrasi dengan data pada sebuah file bernama `users.txt` dan catatan history login/register pada file yang bernama `auth.log`
### login.sh
Program ini bertujuan untuk masuk ke dalam akun/email user yang sudah terdaftar di dalam file `users.txt`
1. **Fungsi login_user**
- Berfungsi apabila user memilih opsi '1' yaitu Login, dalam fungsi ini user diharuskan memasukan email dan password yang sesuai
```bash
login_user() {
    echo "Enter your email:"
    read email
    echo "Enter password:"
    read -s passwd
    echo
```

Apabila email dan password yang dimasukan oleh user terdapat pada `users.txt` maka user akan berhasil login dan tercatat di `auth.log` sebagai LOGIN SUCCESS sebaliknya apabila password atau username tidak sesuai dengan yang ada di `users.txt` maka akan tercatat sebagai LOGIN FAILED 
```bash
    if grep -q "^$email," users.txt; then
        stored_passwd=$(grep "^$email," users.txt | cut -d',' -f5)
        if [ "$passwd" = "$(echo "$stored_passwd" | base64 --decode)" ]; then
            echo "Login successful!"
            echo "$(date "+%Y/%m/%d %h:%m:%s") LOGIN SUCCESS user with email $email has logged in successfully" >> auth.log
            if [[ "$email" == *admin* ]]; then
                admin
            else
                echo "You don't have admin previledge! Welcome!"
                exit
            fi
        else
            echo "Wrong email or password."
            echo "$(date "+%Y/%m/%d %h:%m:%s") LOGIN FAILED failed login attempt on user with email $email" >> auth.log
        fi
    else
        echo "Wrong email or password."
        echo "$(date "+%Y/%m/%d %h:%m:%s") LOGIN FAILED failed login attempt on user with email $email" >> auth.log
    fi
}
```

2. **Fungsi forgot**
- Fungsi ini berjalan ketika user memilih opsi '2' sebagai opsi apabila user lupa password, dalam fungsi ini user diwajibkan menuliskan emailnya dan menjawab security question yang dibuatnya ketika registration. Apabila jawaban user benar maka program akan men-decode password yang tersimpan dalam `user.txt` dan menampilkannya namun apabila salah program akan memunculkan kalimat "wrong answer" dan apabila email yang dimasukan user tidak tersedia di `user.txt` maka akan muncul kalimat "Email not found".
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
Contoh penggunaan fungsi forgot adalah sebagai berikut :


![Screenshot from 2024-03-30 01-23-15](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/146155753/1184ef44-9751-4dea-aea9-7e44fb368eff)

3. **Fungsi admin**
- Fungsi ini berjalan apabila email user yang berhasil login terdapat kata "admin" di dalamnya, terdapat 4 pilihan opsi sebagai admin menu
```bash 
admin() {
    while true;do
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
        "4") echo "Logout" ; exit ;;
        *) echo "Invalid option" ;;
    esac
    done
}
```
Contoh penggunaan admin menu adalah sebagai berikut :


![Screenshot from 2024-03-30 01-29-38](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/146155753/d615dca7-7678-4465-95d0-c6d5c77c68a3)

4. **Fungsi edit user**
- Berjalan ketika user admin memilih opsi '2' pada admin menu, dalam program ini admin diminta memasukkan data  baru pada email user yang dipilih dan memperbaruinya di `user.txt` 
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
        
        if [[ "$email_edit" == *admin* ]]; then
        role="admin"
    else 
        role="user"
    fi

        echo
        encrypted_password=$(echo -n "$new_password" | base64)

        sed -i "/^$email_edit,/c\\$email_edit,$new_username,$new_sec_q,$new_sec_a,$encrypted_password,$role" users.txt
        echo "User has been edited!"
    else
        echo "Email not found."
    fi
}
```
5. **Fungsi delete_user**
- Berjalan ketika user admin meilih opsi '3' pada menu admin, dalam program ini admin diminta menuliskan email data user yang ingin dihapus kemudian program akan menghapus seluruh data user tersebut di dalam file `users.txt`
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

6. **Fungsi utama**
- Fungsi ini merupakan tampilan user interface dari program `login.sh` dimana user diminta untuk memilih opsi yang disediakan. Apabila memilih '1' maka program akan memanggil fungsi login_user, memilih '2' maka akan memanggil fungsi `forgot`, dan ketika memilih '3' maka program akan berhenti berjalan
```bash
echo "Welcome to Login System"
while true; do
    echo "1. Login"
    echo "2. Forgot Password"
    echo "3. Exit"
    read choice
    case "$choice" in
    "1") login_user;;
    "2") forgot ;;
    "3") echo "Thank you!"; exit ;;
    *) echo "Invalid option" ;;
    esac
done
```
Contoh penggunaan program `login.sh` oleh user biasa :

![Screenshot from 2024-03-30 01-32-28](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/146155753/8dcf03b4-120f-4f8d-9d0c-3bf063208006)

Catatan pada `auth.log` apabila terdapat user yang login berhasil atau gagal :

![Screenshot from 2024-03-30 01-59-00](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/146155753/bbab2d3e-216d-4ab4-81f7-ded982637f48)

### register.sh
Program ini digunakan untuk meregistrasi/mendaftarkan user pada file users.txt
1. **Fungsi unique_email** 
Berjalan untuk mengecek apakah email yang dimasukan user sudah terdapat pada `users.txt` atau belum, apabila email yang dimasukan sudah terdapat pada `users.txt` maka program  akan mereturn nilai '1' pada fungsi utama, menuliskan pesan "email sudah digunakan" dan loop akan mengulangi lagi programnya dari awal
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
2. **Fungsi encryption** 
- Berjalan untuk meng-encode password yang diberikan user ke dalam `base64`
```bash 
encryption(){
    encrypt=$(echo -n "$1" | base64)
}
```

3. **Fungsi utama** 
- Dalam program utama ini merupakan interface dari `registration.sh` yang meminta user memasukkan email,username,security question,security answer dan password yang sesuai dengan ketentuan yang berlaku, apabila password tidak sesuai maka loop akan mengulangi programnya,mencatat registrasi gagal ke dalam `auth.log` dan meminta user memasukan password sesuai ketentuan (minimal 1 uppercase, 1 lowercase, 1 digit dan tidak kurang dari 8 karakter) 
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

        if [[ ${#passwd} -lt 8 || ! "$passwd" =~ [[:upper:]] || ! "$passwd" =~ [[:lower:]] || ! "$passwd" =~ [[:digit:]] ]]; then
            echo "Password doesn't meet the requirements, please try again!"
            echo "$(date "+%Y/%m/%d %h:%m:%s") REGISTER FAILED failed registration on email $email" >> auth.log	     
        else 
            break
        fi
    done
```
Setelah selesai dengan masalah perinputan, maka password yang sudah sesuai kriteria yang dimasukkan user akan di-encode oleh fungsi `ecryption` dan apabila email yang dimasukkan mengandung kata `admin` maka role user akan berganti menjadi admin lalu mencatat semua data yang dimasukkan kedalam `users.txt` dan menambahakan pesan registration success ke dalam `auth.log`
```bash 
    encryption "$passwd"

    if [[ "$email" == *admin* ]]; then
        role="admin"
    else 
        role="user"
    fi

    echo "$email,$username,$sec_q,$sec_a,$encrypt,$role" >> users.txt
    echo "$(date "+%Y/%m/%d %h:%m:%s") REGISTER SUCCESS user $username has registered successfully" >> auth.log 
    echo "User registered successfully!"
    break
done
```
Untuk hasil dari program registrasi yang berhasil adalah sebagai berikut :

![Screenshot from 2024-03-30 01-20-05](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/146155753/7c070878-9a14-4bfd-8aa0-0543619286b9)

User tersebut akan tersimpan ke dalam file `users.txt` :

![Screenshot from 2024-03-30 01-21-28](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/146155753/d0e0ad06-ac17-4429-9988-7bdfd97ca7eb)

Catatan dalam `auth.log` apabila user berhasil/gagal registrasi :

![Screenshot from 2024-03-30 01-59-25](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/146155753/2cc79fc2-f32f-4a3d-a7df-6c8c9a8440d4)

## SOAL NOMOR 3

### awal.sh

**1. Mendownload file `genshin.zip` yang berisi `genshin_character.zip` dan `list_character.csv`, lalu melakukan unzip `genshin_character.zip`**
```bash
wget -O genshin.zip "https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN"
unzip genshin.zip
unzip genshin_character.zip 
```

**2. Membuat folder region berdasarkan `list_character.csv`**
```bash
region=$(awk -F "," '{printf ("%s,", $2)}' list_character.csv)
IFS=',' read -r -a listregion <<< "$region"
for ((i=1; i<${#listregion[@]}; i++)); do
  mkdir -p "/home/ubuntu/soal_3/genshin_character/${listregion[i]}"
done
```

**3. Membaca file `list_character.csv`**
```bash
IFS=$'\n' read -d '' -a data < <(tail -n +2 list_character.csv)
```

**4. Melakukan decode nama asli jpg dari hex ke text**
```bash
for asli in genshin_character/*; do
  nama1=$(echo "${asli/*\//}")
  nama2=$(printf "%s" "${nama1%.jpg}" | xxd -r -p) 
```

**5. Mengubah nama hasil decode dengan format `REGION - NAMA - ELEMENT - SENJATA.jpg`**
```bash
  for datachar in "${data[@]}"; do
    datachar2=$(echo "$datachar" | awk -F, '{print $1}')
    if [ "$nama2" = "$datachar2" ]; then
      namabaru=$(echo "$datachar" | awk -F, '{print $2 " - " $1 " - " $3 " - " $4}' | tr -d '\r')
      filebaru="${namabaru}.jpg"
```

**6. Memindahkan gambar karakter berdasarkan regionnya ke folder region yang sesuai dengan `list_character.csv`**
```bash
      regionchar=$(echo "$datachar" | awk -F, '{print $2}' | tr -d '\r')
      mv "genshin_character/$nama1" "genshin_character/$regionchar/$filebaru"
    fi
  done
done
```

**7. Menghitung jumlah senjata**
```bash
awk 'BEGIN {printf "Bow : "} /Bow/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Catalyst : "} /Catalyst/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Claymore : "} /Claymore/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Polearm : "} /Polearm/ { ++n } END {print n}' list_character.csv
awk 'BEGIN {printf "Sword : "} /Sword/ { ++n } END {print n}' list_character.csv
```
![Screenshot from 2024-03-30 15-29-47](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/122516105/75e3816f-66de-4142-adb8-3a1c79d3b2e8)

**8. Menghapus file yang tidak diperlukan**
```bash
rm list_character.csv 
rm genshin_character.zip
rm genshin.zip
```

**Hasil akhir setelah menjalankan `awal.sh`**

![Screenshot from 2024-03-30 15-34-58](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/122516105/8d856c90-529f-4b45-a126-7f474c2815e5)

![Screenshot from 2024-03-30 15-35-09](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/122516105/0432a8d1-554d-4663-afed-5b918778e967)

![Screenshot from 2024-03-30 15-35-24](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/122516105/7b9f1d21-72f1-4312-9b7e-11615c001bd1)

### search.sh

**1. Akses direktori genshin_character dan set found untuk penanda jika url ditemukan**
```bash
cd genshin_character
found=0
``` 

**2. Membuka semua folder region dan mensteghide semua file yang ada pada folder**
```bash
for region in *; do
  if [ -d "$region" ]; then
    for file_jpg in "$region"/*.jpg; do
      if [ -f "$file_jpg" ]; then
        file_basename=$(basename "$file_jpg")
        file_name="${file_basename%.*}"
        steghide extract -sf "$file_jpg" -p "" -xf "$file_name.txt"
```
**3. Mendecode hasil steghide setiap file**
```bash
        file_steg="$file_name.txt"
        steg_code=$(<"$file_steg")
        steg_res=$(echo -n "$steg_code" | base64 --decode 2>/dev/null)
```
**4. Mengecek apakah hasil decode mengandung http**
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

**5.Jika ditemukan maka loop dihentikan**
```bash
  if [ "$found" -eq 1 ]; then  
    break
  fi
done
```

**6. Memindahkan semua file yang berformat jpg/txt/log dari folder genshin_character ke folder soal_3**
```bash
mv /home/ubuntu/soal_3/genshin_character/*.{jpg,txt,log} /home/ubuntu/soal_3/
```

**Hasil akhir setelah menjalankan `search.sh`**
![Screenshot from 2024-03-30 15-38-36](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/122516105/14a0bbca-c396-415e-9504-115421d58a7b)

**Url yang dicari**
![Screenshot from 2024-03-30 15-39-08](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/122516105/c296515f-13eb-44c5-a899-476e79f33cb0)

**Isi dari image.log**
![Screenshot from 2024-03-30 15-39-21](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/122516105/1ca0507e-7e14-4249-84e9-161083fe7933)

**Gambar dari link url**
![Screenshot from 2024-03-30 15-39-34](https://github.com/rmnovianmalcolmb/Sisop-1-2024-MH-IT08/assets/122516105/56f6af15-21cb-4e4b-b5c6-946ac51b4510)


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

### aggregate_minutes_to_hourly_log.sh

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
