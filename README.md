# 👁️ Tes Buta Warna (Ishihara Color Blindness Test) - Flutter Android

Aplikasi mobile Android **100% Offline** berbasis **Flutter** untuk pemeriksaan & diagnosis buta warna mandiri dengan standar medis **Pelat Pseudoisokromatik Ishihara**. Dilengkapi dengan otomatisasi build **APK & AAB (Google Play Store)** menggunakan **GitHub Actions CI/CD**.

---

## ✨ Fitur Utama

- ⚡ **100% Offline & Aman**: Seluruh kalkulasi diagnostik diproses di perangkat tanpa koneksi internet.
- 🎯 **Mode Tes Komprehensif**:
  - **Tes Cepat (12 Pelat)**: Skrining kilat < 2 menit untuk pemeriksaan harian/berkala.
  - **Tes Lengkap (24 Pelat)**: Diagnosis akurat standar medis untuk klasifikasi **Protanopia**, **Deuteranopia**, **Protanomali**, **Deuteranomali**, atau **Buta Warna Total**.
- 🔍 **Pelat Ishihara Vektor Beresolusi Tinggi**: Di-render secara prosedural dengan dukungan pinch-to-zoom & pan interaktif.
- 🔢 **Dialpad Sentuhan Responsif**: Tombol angka besar, tombol cepat *"Tidak Terlihat"*, dan haptic feedback.
- ⏱️ **Pengaturan Timer Medis**: Opsi 3 detik, 5 detik, atau tanpa batas waktu.
- 📄 **Ekspor Laporan Medis ke PDF**: Simpan atau cetak sertifikat hasil tes dengan rincian per pelat.
- 💾 **Riwayat Pemeriksaan Lokal**: Menyimpan catatan hasil tes offline.
- 🌈 **Simulator Penglihatan Buta Warna**: Visualisasi langsung perbedaan pandangan mata Normal vs Protan vs Deutan vs Tritan vs Total.
- 📚 **Panduan & Syarat Kedinasan**: Informasi syarat tes buta warna untuk TNI, POLRI, Kedokteran, Masinis PT KAI, Pelayaran, dan Pilot.
- 🌓 **Tema Gelap & Terang (Material 3)**: Desain modern, bersih, dan hemat baterai (AMOLED Dark Mode).

---

## 🚀 Cara Menjalankan Secara Lokal

### Prasyarat
- Flutter SDK (v3.10.0 atau lebih baru)
- Android Studio / Android SDK (Target SDK 34)

### Langkah Menjalankan:
```bash
# 1. Unduh paket dependencies
flutter pub get

# 2. Jalankan analisis kode & pengujian unit
flutter analyze
flutter test

# 3. Jalankan aplikasi di Emulator atau HP Android
flutter run
```

---

## 🤖 Otomatisasi Build APK & AAB via GitHub Actions

Repository ini telah dilengkapi dengan workflow CI/CD di `.github/workflows/build_release.yml`.

### Cara Otomatis Build di GitHub:
1. **Push ke GitHub**:
   ```bash
   git add .
   git commit -m "feat: inisialisasi aplikasi tes buta warna"
   git push origin main
   ```
2. **Download Hasil APK / AAB**:
   - Buka tab **Actions** di repository GitHub Anda.
   - Klik workflow run yang sedang berjalan.
   - Setelah selesai (tanda centang hijau ✅), scroll ke bagian **Artifacts**:
     - `tes-buta-warna-apk`: File APK siap instal di HP Android Anda.
     - `tes-buta-warna-aab`: File Android App Bundle untuk di-upload ke Google Play Console.
3. **Otomatis Rilis Tag**:
   Jika Anda membuat tag versi baru, GitHub Actions akan otomatis membuat GitHub Release dan melampirkan file APK & AAB:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

---

## 🔑 Konfigurasi Signing Keystore untuk Google Play Store (Opsional)

Untuk mempublikasikan ke Google Play Store, Anda dapat membuat release keystore dan menyimpannya di **GitHub Secrets**:

### 1. Buat Keystore Android
Jalankan perintah ini di terminal:
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Encode Keystore ke Base64
- **Windows (PowerShell)**:
  ```powershell
  [Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) | Set-Clipboard
  ```
- **Linux/macOS**:
  ```bash
  base64 -i upload-keystore.jks | pbcopy
  ```

### 3. Masukkan ke GitHub Repository Secrets
Buka repository Anda di GitHub -> **Settings** -> **Secrets and variables** -> **Actions** -> Tambahkan repository secrets:
- `KEYSTORE_BASE64`: Isi dengan string base64 hasil copy di atas.
- `KEYSTORE_PASSWORD`: Password keystore Anda.
- `KEY_ALIAS`: `upload`
- `KEY_PASSWORD`: Password key Anda.

Setelah secrets dimasukkan, setiap build di GitHub Actions akan otomatis menghasilkan **APK & AAB yang sudah ditandatangani secara resmi (Signed Release)**!

---

## 📦 Panduan Upload ke Google Play Console

1. Buka [Google Play Console](https://play.google.com/console).
2. Buat aplikasi baru: **Tes Buta Warna Indonesia**.
3. Pada menu **Production / Internal Testing**, buat rilis baru dan upload file `app-release.aab` yang telah di-download dari GitHub Artifacts.
4. Isi kelengkapan data aplikasi:
   - **Kategori**: Medis / Kesehatan & Kebugaran (Health & Fitness).
   - **Target Audiens**: Semua umur.
   - **Kebijakan Privasi**: Lampirkan tautan file `PRIVACY_POLICY.md` (misal via GitHub Pages atau Raw GitHub URL).
   - **Deklarasi Izin Data**: Pilih *Tidak ada pengumpulan data pribadi*.
5. Simpan dan kirim untuk peninjauan (Review).

---

## 🩺 Disclaimer Medis

Hasil tes dalam aplikasi ini ditujukan sebagai skrining awal mandiri dan sarana edukasi. Hasil ini tidak menggantikan surat keterangan resmi atau pemeriksaan medis mendalam oleh Dokter Spesialis Mata (Sp.M).
