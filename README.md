# Analisis Penjualan dengan Bash Script

Tujuan dari script bash adalah untuk menganalisis data dari file.csv. Skrip ini menggunakan beberapa perintah untuk mengekstrak wawasan berharga dari data penjualan.

## Langkah-langkah

1. **Unduh Data Penjualan**
   - Jika file `Sandbox.csv` belum ada, skrip akan mengunduhnya dari Google Drive menggunakan perintah `wget`.
   ```bash
   if [ ! -f "Sandbox.csv" ]; then
       wget -O Sandbox.csv "https://drive.google.com/uc?export=download&id=1cC6MYBI3wRwDgqlFQE1OQUN83JAreId0"
   fi
2. **Command 1: Pembeli dengan Penjualan Tertinggi (Perintah A)**
   - Skrip akan menghitung total penjualan untuk setiap pembeli.
   - Kemudian, akan menampilkan nama pembeli dengan penjualan tertinggi.
   ```bash
   echo "A"
   awk -F ',' 'NR>1 {sales[$6]+=$17} END {for (seller in sales) print seller","sales[seller]}' Sandbox.csv | sort -t',' -k2 -nr | head -n 1
3. **Command 2: Segment Pelanggan dengan Profit Terendah (Perintah B)**
   - Skrip akan menghitung total profit untuk setiap segment pelanggan.
   - Kemudian, akan menampilkan segment pelanggan dengan profit terendah.
    ```bash
    echo "B"
    awk -F ',' 'NR>1 {profit[$7]+=$20} END {for (segment in profit) print segment","profit[segment]}' Sandbox.csv | sort -t',' -k2 -n | head -n 1
4. **Command 3: 3 Kategori dengan Total Profit Tertinggi (Perintah C)**
   - Skrip akan menghitung total profit untuk setiap kategori produk.
   - Kemudian, akan menampilkan 3 kategori dengan total profit tertinggi.
    ```bash
    echo "C"
    awk -F ',' 'NR>1 {profit[$14]+=$20} END {for (category in profit) print category","profit[category]}' Sandbox.csv | sort -t',' -k2 -nr | head -n 3
5. **Command 4: Pembelian untuk Pelanggan Bernama Adriaens (Perintah D)**
   - Skrip akan menampilkan tanggal pembelian dan jumlah (quantity) untuk pembelian yang dilakukan oleh pelanggan bernama Adriaens.
   ```bash
   echo "D"
   awk -F ',' '$6 ~ /Adriaens/ {print $2","$18}' Sandbox.csv
## Penjelasan Singkat

- **Awk Command**: Digunakan untuk memproses dan menganalisis baris-baris dari file CSV.
- **Sort Command**: Digunakan untuk mengurutkan hasil output.
- **Head Command**: Digunakan untuk menampilkan sebagian dari hasil output.

## Penggunaan
1. Pastikan Anda memiliki izin eksekusi untuk skrip bash.
   ```bash
   chmod +x sales_analysis.sh
