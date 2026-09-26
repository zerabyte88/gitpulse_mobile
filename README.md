# ⚡ GitPulse Mobile

<div align="center">

<p align="center">
  <img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Flutter-Dark.svg" height="60" alt="Flutter" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Dart-Dark.svg" height="60" alt="Dart" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Github-Dark.svg" height="60" alt="GitHub" />
</p>

### Modern Developer Analytics & Rhythm Tracker for GitHub

[![Flutter](https://img.shields.io/badge/Flutter-v3.24+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-v3.5+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-10B981?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
[![CI/CD](https://img.shields.io/badge/Build-GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)](.github/workflows/build-apk.yml)
[![License](https://img.shields.io/badge/License-MIT-8B5CF6?style=for-the-badge)](LICENSE)

<p align="center">
  <b>GitPulse Mobile</b> adalah aplikasi analitik performa developer modern berbasis Flutter yang mengubah aktivitas mentah GitHub API menjadi visualisasi ritme kerja produktif, agregasi metrik portofolio, dan klasifikasi persona developer secara <i>real-time</i>.
</p>

<p align="center">
  <a href="#-fitur-unggulan">Fitur Unggulan</a> •
  <a href="#-arsitektur--struktur-proyek">Arsitektur & Struktur</a> •
  <a href="#-teknologi--dependensi">Teknologi</a> •
  <a href="#-panduan-instalasi--menjalankan-lokal">Instalasi Lokal</a> •
  <a href="#-unduh-file-apk-cicd">Unduh APK</a> •
  <a href="#-rencana-pengembangan-roadmap">Roadmap</a>
</p>

</div>

---

## 📖 Ringkasan Proyek

Setiap developer memiliki pola dan ritme unik dalam berkarya—mulai dari *early riser* yang produktif sebelum fajar, hingga *night owl* yang menemukan fokus saat malam hening. **GitPulse Mobile** hadir untuk mengeksplorasi dan memvalidasi kebiasaan tersebut secara objektif.

Menggunakan integrasi **GitHub REST API v3**, GitPulse melakukan *fetching* multi-sumber (profil, repositori, dan riwayat *public events*), kemudian memprosesnya menjadi metrik visual:
1. **Peta Jam Produktif**: Distribusi aktivitas komit & interaksi dalam histogram 24 jam.
2. **Kalkulator Persona Pengembang**: Analisis otomatis tipe developer berdasarkan algoritma aktivitas.
3. **Agregasi Dampak Portofolio**: Penghitungan total bintang (*stars*) dan *forks* kumulatif di seluruh repositori publik.
4. **Distribusi Bahasa Pemrograman**: Representasi proporsi bahasa dalam grafik donat interaktif.

---

## 🌟 Fitur Unggulan

<table>
  <tr>
    <td width="50%">
      <h3>⚡ Ritme Produktivitas (Peak Coding Hours)</h3>
      Memetakan riwayat event publik pengguna ke dalam grafik 24 jam interaktif bertenaga <code>fl_chart</code>. Menampilkan zona waktu paling intensif saat developer melakukan <i>push</i>, <i>pull request</i>, atau <i>issue management</i>.
    </td>
    <td width="50%">
      <h3>🎭 Mesin Klasifikasi Persona Developer</h3>
      Algoritma penentu persona cerdas yang menyematkan label dinamis sesuai gaya kerja pengembang:
      <ul>
        <li>🌟 <b>Star Magnet</b>: Repositori berdaya tarik tinggi (&ge; 100 stars)</li>
        <li>⚡ <b>Polyglot Architect</b>: Menguasai ragam bahasa (&ge; 4 bahasa)</li>
        <li>🦉 <b>Midnight Owl Coder</b>: Aktivitas dominan di malam hari (22:00–04:00)</li>
        <li>🌅 <b>Early Bird Developer</b>: Aktivitas dominan di pagi hari (05:00–11:00)</li>
        <li>🚀 <b>Prolific Builder</b>: Portofolio ekstensif (&gt; 20 repositori)</li>
        <li>💻 <b>Dedicated Craftsman</b>: Konsisten mengasah proyek berkualitas</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="50%">
      <h3>📊 Distribusi Bahasa Pemrograman</h3>
      Grafik donat interaktif dengan penyorotan persentase dan palet warna representatif untuk setiap bahasa pemrograman utama yang digunakan di seluruh repositori.
    </td>
    <td width="50%">
      <h3>🔍 Analitik Profil Komprehensif</h3>
      Menampilkan metrik developer utama secara ringkas: total bintang akumulatif, total forks, repositori orisinal vs forked, pengikut, serta tautan langsung ke repositori GitHub.
    </td>
  </tr>
  <tr>
    <td width="50%">
      <h3>🔖 Bookmark & Riwayat Offline</h3>
      Simpan profil developer favorit ke dalam memori lokal perangkat dengan <code>shared_preferences</code>. Membuka profil tersimpan secara instan tanpa perlu mengetik ulang.
    </td>
    <td width="50%">
      <h3>🔑 Manajemen Kuota API (Personal Access Token)</h3>
      Mendukung mode fleksibel:
      <ul>
        <li><b>Anonim (Default)</b>: Kuota 60 request/jam</li>
        <li><b>GitHub PAT</b>: Kuota 5.000 request/jam dengan enkripsi penyimpanan lokal di sandbox perangkat</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      <h3>📋 Generator Snapshot Metrik Sosial</h3>
      Salin ringkasan data profil terformat rapi hanya dengan satu sentuhan, siap dibagikan ke LinkedIn, X/Twitter, WhatsApp, atau portofolio pribadi.
    </td>
  </tr>
</table>

---

## 🎨 Sistem Desain (Design System)

GitPulse Mobile dirancang dengan pendekatan visual modern berkiblat pada standar antarmuka *Developer Midnight Aesthetic*:

| Token | Nilai Warna | Kegunaan |
| :--- | :--- | :--- |
| **Background** | `#0B0F19` (Deep Slate Navy) | Latar belakang kanvas aplikasi |
| **Surface** | `#151D2F` (Muted Indigo Dark) | Kartu kontainer, input form, & panel |
| **Border** | `#2E3E5C` (Slate Outline) | Batas pemisah komponen subtle |
| **Primary Accent** | `#00E5FF` (Neon Cyan) | Aksen utama, tombol aksi, & status aktif |
| **Secondary Accent** | `#8B5CF6` (Vibrant Violet) | Aksen gradasi, persona badge, & chart |
| **Success / Highlights** | `#10B981` (Emerald Green) | Indikator keberhasilan & rasio positif |
| **Tipografi** | Google Fonts: `Outfit` | Tipografi geometris bersih dengan keterbacaan tinggi |

---

## 🏛️ Arsitektur & Struktur Proyek

Proyek ini menerapkan prinsip **Clean Architecture (Layered)** yang memisahkan *business logic*, presentasi antarmuka, dan akses data jaringan:

```text
gitpulse_mobile/
├── .github/
│   └── workflows/
│       └── build-apk.yml          # Otomasi CI/CD kompilasi APK rilis
├── android/                       # Konfigurasi native Android (Gradle, Manifest)
├── lib/
│   ├── main.dart                  # Entry-point aplikasi & inisialisasi tema
│   ├── models/                    # Model data & kalkulasi analitik
│   │   ├── github_repo.dart       # Model entitas repositori
│   │   ├── github_user.dart       # Model profil developer
│   │   └── user_stats.dart        # Engine kalkulasi metrik, ritme jam, & persona
│   ├── screens/                   # Tampilan layar utama
│   │   ├── home_screen.dart       # Form pencarian, bookmark, & modal input token
│   │   └── stats_detail_screen.dart # Dashboard analitik lengkap, chart, & list repo
│   ├── services/                  # Layer integrasi API & persistensi
│   │   ├── github_api_service.dart # Konsumsi GitHub REST API v3
│   │   └── storage_service.dart   # Manajemen cache lokal & Personal Access Token
│   ├── theme/                     # Token desain warna, tipografi, & tema gelap
│   │   └── app_theme.dart         # Konfigurasi tema Material 3
│   └── widgets/                   # Komponen UI modular
│       ├── activity_chart.dart    # Komponen visualisasi bar chart 24 jam
│       ├── language_chart.dart    # Komponen visualisasi donut chart bahasa
│       ├── repo_tile.dart         # Kartu informasi repositori interaktif
│       └── stat_card.dart         # Widget kartu metrik ringkas
├── test/
│   └── widget_test.dart           # Pengujian unit parser model & kalkulasi skor
├── web/                           # Entry point kompilasi Web/PWA
└── pubspec.yaml                   # Deklarasi dependensi paket & aset
```

---

## 🛠️ Teknologi & Dependensi

| Paket / Pustaka | Versi | Fungsi & Kegunaan |
| :--- | :--- | :--- |
| **[Flutter SDK](https://flutter.dev)** | `^3.24.0` | Framework pengembangan UI multi-platform |
| **[Dart](https://dart.dev)** | `^3.5.0` | Bahasa pemrograman bertipe aman |
| **[fl_chart](https://pub.dev/packages/fl_chart)** | `^1.2.0` | Render visualisasi grafik bar (ritme jam) dan donut (bahasa) |
| **[http](https://pub.dev/packages/http)** | `^1.6.0` | Klien HTTP untuk interaksi dengan GitHub REST API v3 |
| **[google_fonts](https://pub.dev/packages/google_fonts)** | `^8.2.1` | Tipografi dinamis keluarga font `Outfit` |
| **[shared_preferences](https://pub.dev/packages/shared_preferences)** | `^2.5.5` | Penyimpanan persisten lokal untuk bookmark dan token pengguna |
| **[intl](https://pub.dev/packages/intl)** | `^0.20.3` | Format angka metrik dan konversi waktu lokal |
| **[flutter_lints](https://pub.dev/packages/flutter_lints)** | `^6.0.0` | Penegakan *code style* & analisis statis standar komunitas |

---

## 💻 Panduan Instalasi & Menjalankan Lokal

### Prasyarat Sistem
- **Flutter SDK**: Versi `3.24.0` atau lebih baru ([Instalasi Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK**: Versi `3.5.0` atau lebih baru
- **Android Studio / VS Code**: Terpasang ekstensi Flutter & Dart
- **Perangkat**: Emulator Android, HP Android terhubung via USB Debugging, atau Google Chrome

### Langkah Menjalankan

1. **Clone Repositori**:
   ```bash
   git clone https://github.com/zerabyte88/gitpulse_mobile.git
   cd gitpulse_mobile
   ```

2. **Unduh Dependensi**:
   ```bash
   flutter pub get
   ```

3. **Verifikasi Analisis Kode & Pengujian Unit**:
   ```bash
   flutter analyze
   flutter test
   ```

4. **Jalankan Aplikasi**:
   * Mode Web (Google Chrome):
     ```bash
     flutter run -d chrome
     ```
   * Mode Mobile (Android Device / Emulator):
     ```bash
     flutter run -d android
     ```

5. **Build APK Rilis Secara Mandiri**:
   ```bash
   flutter build apk --release
   # File APK tersimpan di: build/app/outputs/flutter-apk/app-release.apk
   ```

---

## 🤖 Unduh File APK (CI/CD Otomatis)

Repository ini telah dilengkapi dengan pipeline otomatis **GitHub Actions** (`.github/workflows/build-apk.yml`). Setiap pembaruan kode akan memicu pengujian otomatis dan mengompilasi APK siap pakai:

1. Buka repositori ini di GitHub.
2. Klik tab **Actions** pada navigasi atas repositori.
3. Pilih eksekusi alur kerja **Build & Release GitPulse APK** terbaru (ditandai dengan centang hijau).
4. Gulir ke bagian **Artifacts** di bagian bawah halaman.
5. Unduh file **GitPulse-Android-APK**, ekstrak file ZIP, dan instal `app-release.apk` di smartphone Android Anda.

---

## 🗺️ Rencana Pengembangan (Roadmap)

- [x] Pencarian profil developer & kalkulasi metrik portofolio.
- [x] Visualisasi 24-jam ritme komit & peak productivity hours.
- [x] Otomasi penentuan persona pengembang berbasis kebiasaan kode.
- [x] Pengurutan repositori terbaik berdasarkan bintang dan popularitas.
- [x] Penyimpanan bookmark offline & opsi GitHub Personal Access Token.
- [ ] **Export Card as Image**: Fitur ekspor ringkasan persona & ritme menjadi format PNG/kartu grafis siap share.
- [ ] **Developer Comparison**: Fitur perbandingan statistik *head-to-head* antara dua akun developer.
- [ ] **Year-in-Review / Wrapped**: Rekapitulasi tahunan aktivitas komit dan capaian proyek.
- [ ] **Home Screen Widget**: Widget Android untuk memantau aktivitas developer langsung dari layar utama.

---

## 🤝 Kontribusi

Kontribusi selalu disambut dengan hangat! Silakan ikuti langkah berikut:

1. **Fork** repositori ini.
2. Buat *feature branch* baru:
   ```bash
   git checkout -b feature/FiturKerenKamu
   ```
3. Lakukan *commit* terhadap perubahan Anda:
   ```bash
   git commit -m "feat: Menambahkan fitur analitik baru"
   ```
4. *Push* branch Anda:
   ```bash
   git push origin feature/FiturKerenKamu
   ```
5. Buka **Pull Request** di GitHub dan jelaskan pembaruan yang Anda buat.

---

## 📄 Lisensi

Proyek ini didistribusikan di bawah lisensi **MIT License**. Silakan baca berkas [LICENSE](LICENSE) untuk informasi hak cipta dan izin penggunaan selengkapnya.

<div align="center">

Dibuat dengan ❤️ untuk komunitas developer oleh [zerabyte88](https://github.com/zerabyte88)

</div>

