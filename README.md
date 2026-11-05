# Sehat Bersama — Smart Village Mobile App
> Aplikasi Layanan Fasilitas Kesehatan Berbasis LBS (Location-Based Service) & Geofencing untuk Warga Pedesaan.

Proyek ini dikembangkan untuk memenuhi tugas **Ujian Tengah Semester (UTS) Praktikum Pemrograman Mobile**. Dibangun menggunakan **Flutter** dengan pendekatan arsitektur bersih (*Clean Feature-first*), data statis yang realistis, serta mengadopsi standar **Modern Minimalist Healthcare Design** dan panduan **Google Anti-AI-Slop**.

---

## 📱 Daftar 10 Layar & Fitur PRD

Aplikasi ini mengimplementasikan 10 antarmuka pengguna sesuai dengan rancangan pada folder `docs/design` dan seluruh persyaratan fungsional pada `docs/PRD.md`:

| No | Layar Aplikasi | Path Fitur | Fitur PRD | Deskripsi |
|:---:|:---|:---|:---:|:---|
| **1** | **Welcome Screen** | `lib/features/welcome/` | FR-01, FR-06 | Splash onboarding dengan citra pedesaan, badge status LBS aktif, dan tombol akses cepat. |
| **2** | **Beranda Smart Village** | `lib/features/home/` | FR-01, FR-02, FR-04 | Header lokasi warga, pencarian faskes, filter kategori, kartu pemicu geofencing radar, dan faskes terdekat. |
| **3** | **Peta Lokasi Interaktif** | `lib/features/map/` | FR-03, FR-04 | Peta nyata **OpenStreetMap** (`flutter_map`), pin faskes berkode warna, radius geofencing 500m & 1km, serta tombol zoom & re-center. |
| **4** | **Daftar Fasilitas Kesehatan** | `lib/features/facility_list/` | FR-01, FR-02 | Tampilan komprehensif seluruh faskes, filter dinamis, status operasional (Buka/Tutup/IGD 24 Jam), dan dukungan BPJS. |
| **5** | **Detail Fasilitas Kesehatan** | `lib/features/facility_detail/` | FR-02, FR-05 | Informasi profil faskes, kontak darurat, grid 8 layanan medis interaktif (`ServiceSheetModal`), dan cuplikan peta live. |
| **6** | **Notifikasi Geofencing Lockscreen** | `lib/features/geofencing/` | FR-04, FR-06 | Simulasi antarmuka layar terkunci (*lockscreen*) saat warga memasuki radius 500m dari RSUD. |
| **7** | **Rute & Navigasi GPS** | `lib/features/route/` | FR-03, FR-05 | Polyline rute jalan nyata dari lokasi warga ke RSUD, instruksi belokan, estimasi waktu Mobil (4 mnt), Motor (15 mnt), dan Jalan Kaki (6 mnt). |
| **8** | **Fasilitas Favorit** | `lib/features/favorites/` | FR-07 | Pengelolaan faskes yang disimpan oleh warga dengan fitur bookmark interaktif. |
| **9** | **Profil Pengguna** | `lib/features/profile/` | FR-06, FR-07 | Data kependudukan warga (Andi Pratama, NIK terverifikasi, No. BPJS), switch pengaturan LBS/Geofencing, dan simulasi demo. |
| **10** | **Geofence Alert Modal** | `lib/features/geofencing/` | FR-04 | Dialog radar pop-up saat warga terdeteksi berada di radius zona siaga Puskesmas Sukamaju (500 meter). |

---

## 🗺️ Integrasi Peta & Data Geografis Riil

Aplikasi terhubung langsung ke tile server resmi **OpenStreetMap** tanpa memerlukan API Key atau Google Cloud Billing:
- **Titik Lokasi Warga**: Desa Sukamaju Krajan, Kec. Ciawi, Kab. Bogor (`-6.6590, 106.8415`).
- **RSUD Kabupaten X (RSUD Ciawi)**: Jl. Raya Puncak - Gadog No. 479 (`-6.6578, 106.8488`) — Jarak ~1.2 km.
- **Puskesmas Sukamaju**: Jl. Raya Ciawi - Sukabumi No. 12 (`-6.6625, 106.8430`) — Jarak ~500 m.
- **Klinik Sehat Mandiri**: Jl. Veteran III No. 88, Banjarsari (`-6.6515, 106.8520`) — Jarak ~2.1 km.
- **RS Harapan Bunda**: Jl. Raya Tajur No. 168 (`-6.6430, 106.8390`) — Jarak ~3.4 km.

---

## 🎨 Standar Desain Anti-AI-Slop

Proyek ini menerapkan prinsip desain bersih untuk menghindari tampilan generik buatan AI (*anti-slop*):
1. **Tipografi Terstruktur**: Menggunakan font **Inter** (`GoogleFonts.inter`) dengan rasio hierarki yang tegas dan konsisten.
2. **Palet Warna Minimalis**:
   - `Primary`: `#0284C7` (Sky Blue) & `Primary Container`: `#0369A1`
   - `Surface Pure`: `#FFFFFF` & `Surface Subtle`: `#F9FAFB`
   - `Border`: `1px solid #E5E7EB` (Flat outline aesthetic tanpa drop shadow tebal/buram).
   - `Semantic Badges`: Status Sukses/Buka `#059669` pada `#D1FAE5`, IGD/Darurat `#DC2626` pada `#FEE2E2`.
3. **Copywriting Otentik**: Teks instruksi, jam layanan poliklinik, dan nama faskes disesuaikan dengan konteks pelayanan kesehatan masyarakat di Indonesia.

---

## 📂 Struktur Direktori Proyek

```
lib/
├── core/
│   └── theme/
│       ├── app_colors.dart         # Design tokens palet warna modern minimalist
│       ├── app_typography.dart     # Hierarki tipografi Inter
│       └── app_theme.dart          # Konfigurasi ThemeData & CardThemeData flat outline
├── data/
│   ├── models/
│   │   ├── facility_model.dart     # Model data fasilitas kesehatan
│   │   ├── service_item_model.dart # Model 8 layanan medis
│   │   └── user_profile_model.dart # Model profil warga desa
│   └── dummy/
│       └── dummy_data.dart         # Data statis komprehensif faskes & profil
├── features/
│   ├── welcome/screens/            # Layar 1: Welcome Screen
│   ├── navigation/screens/         # Persistent Bottom Navigation Bar
│   ├── home/screens/               # Layar 2: Beranda
│   ├── map/screens/ & widgets/     # Layar 3: Peta OpenStreetMap & Map Sheet
│   ├── facility_list/screens/      # Layar 4: Daftar Lengkap Faskes
│   ├── facility_detail/            # Layar 5: Detail Fasilitas & Sheet 8 Layanan
│   ├── geofencing/screens/ & widgets/ # Layar 6 & 10: Lockscreen Demo & Alert Modal
│   ├── route/screens/              # Layar 7: Rute Navigasi Polyline
│   ├── favorites/screens/          # Layar 8: Fasilitas Favorit
│   └── profile/screens/            # Layar 9: Profil Andi Pratama
├── shared/widgets/                 # Tombol stadium pill, filter chip, status badge
└── main.dart                       # Entry point aplikasi
```

---

## 🚀 Panduan Menjalankan Aplikasi

### 1. Prasyarat
- Flutter SDK versi `>=3.13.5` (disarankan Flutter 3.27+).
- Perangkat Android (USB Debugging aktif), emulator Android, atau Google Chrome.

### 2. Instalasi Dependensi
```bash
flutter pub get
```

### 3. Menjalankan di Mode Pengembangan (Development)
```bash
# Menjalankan di perangkat/emulator aktif:
flutter run

# Atau jalankan di Chrome:
flutter run -d chrome
```

### 4. Membangun File APK (Android)
Untuk menghasilkan file APK yang ringan dan optimal (hanya **~17 MB**):
```bash
flutter build apk --release --split-per-abi
```
File APK akan berada pada direktori:
```
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

---

## 🧪 Pengujian & Kualitas Kode

Proyek ini telah lulus verifikasi kode otomatis tanpa catatan error atau warning:

- **Analisis Statis (`flutter analyze`)**:
  ```bash
  $ flutter analyze
  Analyzing uts-hospital-smart-village...
  No issues found!
  ```
- **Automated Widget & Logic Testing (`flutter test`)**:
  ```bash
  $ flutter test
  00:04 +5: All tests passed!
  ```
  Mencakup pengujian Welcome Screen, Detail Fasilitas & Modal Layanan, Rute Navigasi, Simulasi Geofencing, dan Integritas Data Statis.
