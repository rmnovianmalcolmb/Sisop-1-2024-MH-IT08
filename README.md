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
## Penjelasan Singkat
- **Awk Command**: Digunakan untuk memproses dan menganalisis baris-baris dari file CSV.
- **Sort Command**: Digunakan untuk mengurutkan hasil output.
- **Head Command**: Digunakan untuk menampilkan sebagian dari hasil output.
## Penggunaan
   Pastikan Anda memiliki izin eksekusi untuk skrip bash.
   Eksekusi Command dibawah terlebih dahulu agar mendapatkan izin
   ```bash
   chmod +x sales_analysis.sh
   ```

## SOAL NOMOR 2
## Skrip Sistem Login

Skrip ini merupakan sistem login sederhana yang dibuat menggunakan bahasa Bash. Skrip ini memungkinkan pengguna untuk melakukan login, pemulihan kata sandi jika lupa, serta tugas-tugas administratif seperti menambah, mengedit, dan menghapus pengguna.

## Fitur

1. **Login**:
   - Pengguna diminta untuk memasukkan email dan kata sandi untuk masuk.
   - Jika kredensial yang dimasukkan cocok dengan yang tersimpan, pengguna dianggap berhasil login.
   - Setiap percobaan login yang berhasil atau gagal akan dicatat ke dalam file `auth.log`.

2. **Lupa Kata Sandi**:
   - Jika pengguna lupa kata sandi, mereka dapat memulihkannya dengan menjawab pertanyaan keamanan yang telah ditetapkan sebelumnya.
   - Pertanyaan keamanan dan jawaban pengguna disimpan dalam berkas `users.txt`.

3. **Menu Admin**:
   - Pengguna dengan peran admin memiliki akses ke menu admin yang menyediakan fungsi tambahan:
     - **Tambah Pengguna**: Admin dapat menambahkan pengguna baru ke dalam sistem dengan mengisi informasi yang diperlukan.
     - **Edit Pengguna**: Admin dapat mengubah informasi pengguna seperti nama pengguna, pertanyaan keamanan, jawaban, dan kata sandi.
     - **Hapus Pengguna**: Admin dapat menghapus akun pengguna dari sistem.
     - **Logout**: Admin dapat keluar dari menu admin dan kembali ke menu utama.

## Penggunaan

1. **Persiapan**:
   - Pastikan skrip dan berkas `users.txt` berada dalam direktori yang sama.
   - Pastikan skrip memiliki izin eksekusi (jalankan `chmod +x login_system.sh` jika diperlukan).

2. **Menjalankan Skrip**:
   - Buka terminal dan jalankan skrip dengan perintah `./login_system.sh`.

3. **Menu Utama**:
   - Pengguna akan disajikan dengan pilihan menu untuk login, pemulihan kata sandi, atau keluar dari skrip.

4. **Login**:
   - Masukkan email dan kata sandi yang sesuai untuk masuk.
   - Jika berhasil, pengguna akan masuk ke dalam sistem sesuai dengan hak akses mereka.

5. **Pemulihan Kata Sandi**:
   - Jika pengguna lupa kata sandi, mereka dapat memulihkannya dengan menjawab pertanyaan keamanan yang telah ditetapkan sebelumnya.

6. **Menu Admin**:
   - Jika pengguna memiliki peran admin, mereka dapat mengakses menu admin untuk melakukan tugas administratif.

# SKRIP REGISTER.SH

Ini adalah sistem registrasi pengguna sederhana yang diimplementasikan dalam skrip Bash. Skrip ini memungkinkan pengguna untuk mendaftar dengan alamat email yang unik, nama pengguna, pertanyaan keamanan beserta jawabannya, dan kata sandi yang kuat sesuai dengan kriteria tertentu.

## Fitur-fitur

- **Validasi Email:** Memeriksa apakah email yang dimasukkan oleh pengguna sudah unik.
- **Enkripsi Kata Sandi:** Mengenkripsi kata sandi pengguna menggunakan basis64.
- **Validasi Keamanan Kata Sandi:** Memastikan bahwa kata sandi memenuhi kriteria tertentu (panjang minimum, huruf besar, huruf kecil, angka, simbol, dan tidak mirip dengan informasi sensitif lainnya).
- **Penugasan Peran:** Menetapkan peran "admin" untuk email yang mengandung kata "admin" dan "user" untuk yang lainnya.
- **Pencatatan Log:** Mencatat percobaan registrasi dan hasilnya dalam file `auth.log`.

## Cara Menggunakan

1. **Jalankan Skrip:**
   - Jalankan skrip di terminal: `./User.sh`

2. **Proses Registrasi:**
   - Masukkan alamat email yang unik.
   - Berikan nama pengguna.
   - Tentukan pertanyaan keamanan beserta jawabannya.
   - Masukkan kata sandi yang kuat sesuai dengan kriteria yang ditentukan.

3. **Pencatatan Log:**
   - Percobaan registrasi dan hasilnya akan dicatat dalam file `auth.log`.

## Persyaratan

- Lingkungan shell Bash
- Perintah `base64` untuk enkripsi kata sandi

## Struktur File

- `User.sh`: Skrip utama untuk registrasi pengguna.
- `users.txt`: File untuk menyimpan data pengguna yang terdaftar.
- `auth.log`: File log untuk percobaan registrasi dan hasilnya.

## Catatan

- Pastikan bahwa skrip dapat dieksekusi (`chmod +x User.sh`).
- Modifikasi kriteria kata sandi atau logika penugasan peran sesuai kebutuhan.
- Tangani kasus-kasus error seperti kegagalan menulis file atau input yang tidak valid.



