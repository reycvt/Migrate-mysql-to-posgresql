# Migrasi MySQL ke PostgreSQL dengan pgloader  
**Created by adi.kannatasik@gmail.com**  

## 1. Instalasi pgloader  

### Untuk Sistem Ubuntu/Debian  
```bash
# Update package list dan instal dependensi
sudo apt-get update
sudo apt-get install -y curl build-essential sbcl make unzip

# Unduh pgloader versi terbaru
curl -LO https://github.com/pgloader/pgloader/releases/download/v3.6.7/pgloader-bundle-ubuntu-20.04.zip

# Ekstrak dan pasang
unzip pgloader-bundle-ubuntu-20.04.zip
sudo mv pgloader /usr/local/bin/

# Verifikasi instalasi
pgloader --version
```

### Troubleshooting  
Jika muncul error:  
1. Pastikan file binary dapat dijalankan:  
   ```bash
   chmod +x /usr/local/bin/pgloader
   ```
2. Jika versi tidak muncul, cek path instalasi atau unduh ulang binary.

---  

## 2. Konfigurasi File Migrasi  
Buat/modifikasi file `generate.sh` dengan editor teks:  
```bash

# Konfigurasi koneksi database
LOAD DATABASE
     FROM mysql://username:password@host/database
     INTO postgresql://username:password@host/database
```

---  

## 3. Eksekusi Migrasi  
Jalankan skrip:  
```bash
bash generate.sh
```  
Atau langsung gunakan pgloader:  
```bash
pgloader --dynamic-space-size 16384 file_config.load
```  
**Keterangan Opsi**:  
- `--dynamic-space-size 16384`: Mengalokasikan memori tambahan (opsional).  
- `file_config.load`: File konfigurasi migrasi spesifik.  

---  

## Catatan Penting  

### Persiapan Database PostgreSQL  
- **Kolom NULL**: Pastikan tabel tujuan mendukung nilai `NULL` untuk kolom yang berisi `0000-00-00 00:00:00` dari MySQL.  
- **Backup Data**: Selalu buat backup database sumber dan tujuan sebelum migrasi.  

### Konversi Tipe Data  
Gunakan direktif `CAST` dalam file `.load` untuk handle perbedaan tipe data, contoh:  
```lisp
CAST column_name AS type USING conversion_function
```  

### Optimasi  
- **Batch Size**: Tambahkan `WITH batch_size = 10000` di file `.load` untuk migrasi besar.  
- **Monitoring**: Pantau log proses migrasi untuk deteksi error dini.  

---  
**Disclaimer**: Dokumen ini berlaku untuk pgloader v3.6.7. Sesuaikan versi jika diperlukan.  
