# ⚡ GitPulse Mobile

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-brightgreen)
![CI/CD](https://img.shields.io/badge/Build-GitHub%20Actions%20APK-blue?logo=githubactions&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-purple)

**A modern Android & cross-platform app to track GitHub developer statistics, coding rhythm, peak productivity hours, and profile insights.**

[Fitur Utama](#-fitur-utama) • [Tangkapan Layar](#-fitur-utama) • [Teknologi](#-teknologi--arsitektur) • [Download APK](#-cara-mendapatkan-file-apk) • [Instalasi Lokal](#-menjalankan-secara-lokal)

</div>

---

## 🌟 Fitur Utama

- 🔍 **Cari & Analisis Profil Pengguna**: Cukup ketik sembarang username GitHub untuk melihat total bintang yang diraih di semua repositori, total forks, repositori publik, serta pengikut.
- ⚡ **Ritme Jam Produktif (Peak Hours)**: Memetakan aktivitas event publik GitHub ke dalam grafik 24 jam interaktif untuk mendeteksi kapan jam paling produktif kamu ngoding (Dini hari, Fajar, Pagi, Siang, Sore, atau Malam).
- 🎭 **Developer Persona**: Gelar otomatis berdasarkan gaya ngoding kamu (misal: *🌟 Star Magnet*, *🦉 Midnight Owl Coder*, *⚡ Polyglot Architect*, *🌅 Early Bird Developer*).
- 📊 **Visualisasi Bahasa Pemrograman**: Donut chart interaktif bertenaga `fl_chart` yang merinci persentase bahasa pemrograman yang paling sering kamu pakai.
- 🔖 **Bookmark & Riwayat Pencarian**: Simpan akun-akun developer favorit secara lokal di perangkat tanpa perlu mengetik ulang setiap kali membuka aplikasi.
- 📋 **Snapshot Ringkasan Profil**: Salin ringkasan metrik statistik dengan format rapi dalam 1 klik untuk dibagikan ke WhatsApp, LinkedIn, atau Twitter/X.
- 🔑 **Dukungan Personal Access Token**: Opsi input token GitHub tersimpan lokal secara aman untuk meningkatkan kuota API dari 60 menjadi 5.000 request per jam.
- 🤖 **Otomatisasi Build APK (CI/CD)**: Setiap kali kode di-push ke GitHub, workflow GitHub Actions akan otomatis meng-compile file APK rilis yang siap diunduh dan dipasang di HP Android kamu.

---

## 🛠️ Teknologi & Arsitektur

GitPulse Mobile dibangun dengan arsitektur bersih (*layered architecture*):

- **Framework**: [Flutter](https://flutter.dev) (Channel Stable) & [Dart 3](https://dart.dev)
- **UI Design System**: Material 3 dengan custom *Developer Midnight Dark Theme* (Slate Dark `#0B0F19`, Cyan Glow `#00E5FF`, Violet Accent `#8B5CF6`)
- **Typography**: Google Fonts (`Outfit`)
- **Charts / Visualisasi**: [`fl_chart`](https://pub.dev/packages/fl_chart)
- **HTTP Client**: [`http`](https://pub.dev/packages/http) mengonsumsi GitHub REST API v3
- **Local Storage**: [`shared_preferences`](https://pub.dev/packages/shared_preferences)
- **CI/CD**: GitHub Actions (`.github/workflows/build-apk.yml`)

---

## 📥 Cara Mendapatkan File APK

1. Push repository ini ke akun GitHub kamu.
2. Buka tab **Actions** di repository GitHub kamu.
3. Klik workflow **Build & Release GitPulse APK** terbaru.
4. Pada bagian **Artifacts**, download file zip **GitPulse-Android-APK**.
5. Ekstrak dan instal `app-release.apk` langsung di smartphone Android kamu!

---

## 💻 Menjalankan Secara Lokal

Pastikan Flutter SDK telah terinstal di komputermu:

```bash
# 1. Masuk ke direktori project
cd gitpulse_mobile

# 2. Ambil dependensi
flutter pub get

# 3. Jalankan analisa statis & test
flutter analyze
flutter test

# 4. Jalankan aplikasi (Web / Chrome)
flutter run -d chrome

# 5. Jalankan di perangkat Android (jika terhubung)
flutter run -d android
```

---

## 📄 Lisensi
Didistribusikan di bawah Lisensi MIT. Bebas digunakan, dimodifikasi, dan dikembangkan lebih lanjut.
