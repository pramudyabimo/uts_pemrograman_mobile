# Product Requirements Document (PRD)

**Project Name:** Sehat Bersama Smart Village App
**Platform:** Mobile (Android & iOS via Flutter)
**Version:** 1.0.0
**Target Audience:** Masyarakat dan Warga Desa di Kabupaten X

---

## 1. Executive Summary
Aplikasi "Sehat Bersama Smart Village" adalah solusi *mobile* berbasis *Location Based Service* (LBS) dan *Geofencing* yang dirancang untuk mendukung ekosistem *Smart Village* di Kabupaten X. Aplikasi ini bertujuan memudahkan warga dalam mencari, mengetahui detail layanan, dan menavigasi rute menuju fasilitas kesehatan terdekat (RSUD, Puskesmas, Klinik, Bidan) dengan antarmuka yang modern, minimalis, dan intuitif.

## 2. Goals & Objectives
* **Aksesibilitas:** Memberikan kemudahan akses informasi terkait lokasi dan layanan fasilitas kesehatan bagi masyarakat desa.
* **Kecepatan Tanggap:** Memanfaatkan teknologi *Geofencing* untuk memberikan notifikasi proaktif saat warga berada di sekitar fasilitas kesehatan.
* **Navigasi Presisi:** Menyediakan rute yang akurat menggunakan pemetaan digital interaktif.

## 3. Scope of Work (Ruang Lingkup)
### 3.1. In-Scope
* Pemetaan fasilitas kesehatan dengan *marker* pada peta.
* Fitur pencarian dan filter kategori faskes.
* Kalkulasi jarak dan rute navigasi (*Polyline*).
* Sistem *background geofencing* untuk notifikasi area radius faskes.
* Manajemen profil pengguna dasar dan daftar faskes favorit.

### 3.2. Out-of-Scope (Fase 1)
* Sistem *booking* antrean rumah sakit atau jadwal dokter.
* Fitur *chat/telemedicine* langsung dengan tenaga medis.
* Pembayaran/Integrasi *payment gateway*.

---

## 4. User Personas
* **Warga Desa (Pengguna Utama):** Membutuhkan informasi rute tercepat ke RS atau Puskesmas saat kondisi darurat atau untuk kunjungan rutin. Menginginkan aplikasi yang ringan dan mudah digunakan.

---

## 5. Functional Requirements (FR)

| ID | Fitur | Deskripsi | Prioritas |
|---|---|---|---|
| FR-01 | **Autentikasi & Profil** | Pengguna dapat melihat profil pengguna (Nama, ID) dan mengatur bahasa serta preferensi notifikasi. | Medium |
| FR-02 | **LBS & Pemetaan** | Sistem dapat mendeteksi lokasi GPS pengguna (*real-time*) dan merender *marker* fasilitas kesehatan di atas peta. | High |
| FR-03 | **Eksplorasi & Filter** | Pengguna dapat mencari faskes melalui *search bar* dan memfilter berdasarkan kategori (RS, Puskesmas, Klinik). | High |
| FR-04 | **Detail Fasilitas** | Menampilkan informasi lengkap faskes: Foto, Nama, Alamat, Jarak, Jam Operasional, dan Grid Ikon Layanan (24 Jam, BPJS, UGD, dll). | High |
| FR-05 | **Rute & Navigasi** | Menggambar *polyline* dari lokasi *user* ke faskes tujuan, beserta kalkulasi estimasi jarak dan waktu tempuh. | High |
| FR-06 | **Notifikasi Geofencing** | Membangkitkan *pop-up* / *push notification* otomatis (misal: "Anda Masuk Area Geofencing") jika pengguna berada dalam radius < 500m dari faskes. | High |
| FR-07 | **Manajemen Favorit** | Pengguna dapat menyimpan dan menghapus faskes dari daftar favorit pribadi. | Low |

---

## 6. Non-Functional Requirements (NFR)

* **UI/UX Design:** Mengadopsi gaya desain **Modern Minimalis**. Penggunaan ruang kosong (*whitespace*) yang optimal, warna latar netral (putih/abu-abu muda), dan elemen aksi (tombol/rute) menggunakan aksen warna biru yang kontras.
* **Performa Peta:** Proses inisialisasi peta dan kalkulasi rute (*Directions API*) harus diselesaikan dalam waktu kurang dari 3 detik (pada jaringan 4G/WIFI stabil).
* **Akurasi Lokasi:** Deviasi pembacaan GPS pengguna memiliki margin toleransi maksimal 10 meter untuk mencegah *false alarm* pada sistem Geofencing.
* **Efisiensi Baterai:** Pemantauan *Geofencing* di latar belakang harus menggunakan API *native* OS yang teroptimasi agar penggunaan baterai tidak melebihi 3-5% per jam saat *idle*.
* **Ketersediaan Offline (Partial):** Data kategori dan daftar faskes dapat di-*cache* di memori lokal (SQLite/Hive) agar tetap bisa dilihat informasinya saat tidak ada sinyal (meskipun peta/rute membutuhkan internet).

---

## 7. Teknologi & Integrasi
* **Frontend:** Flutter (Dart).
* **State Management:** BLoC / Riverpod.
* **Maps & Routing:** Google Maps Flutter SDK, Google Directions API.
* **Location Service:** `geolocator`, `flutter_background_geolocation`.
* **Local Storage:** SQLite (`sqflite`).
* **Design System:** Material 3 (dengan kustomisasi tema spesifik minimalis).

## 8. Success Metrics
* **Engagement:** Waktu rata-rata pengguna menemukan faskes dan memulai navigasi < 30 detik.
* **Akurasi Geofencing:** > 95% notifikasi berhasil terkirim tepat saat pengguna memasuki radius yang ditentukan.
* **Stabilitas:** *Crash-free rate* > 99% di perangkat Android maupun iOS.