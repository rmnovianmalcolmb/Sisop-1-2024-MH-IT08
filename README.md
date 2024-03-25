## SOAL NOMOR 1

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
# Skrip Sistem Login

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

## Catatan Penting

- Pastikan berkas `users.txt` teratur dan sesuai dengan format yang diharapkan.
- Skrip ini hanya untuk tujuan demonstrasi dan sebaiknya tidak digunakan dalam lingkungan produksi tanpa penyesuaian keamanan yang tepat.

---

Silakan gunakan README ini sebagai panduan untuk menggunakan skrip sistem login Anda. Sesuaikan dengan kebutuhan dan pastikan untuk memperhatikan petunjuk penggunaan dan catatan penting yang disertakan.


