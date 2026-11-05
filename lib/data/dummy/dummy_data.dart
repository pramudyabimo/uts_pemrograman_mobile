import 'package:flutter/material.dart';
import '../models/facility_model.dart';
import '../models/service_item_model.dart';
import '../models/user_profile_model.dart';

class DummyData {
  DummyData._();

  static const double userLatitude = -6.6590;
  static const double userLongitude = 106.8415;
  static const String userLocationName = 'Desa Sukamaju Krajan, Kec. Ciawi';

  static final UserProfileModel userProfile = UserProfileModel(
    name: 'Andi Pratama',
    phone: '0812.3456.7890',
    nik: '3201123456780001',
    isNikVerified: true,
    location: 'Smart Village Krajan, Kabupaten X',
    avatarUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    emergencyAlertsEnabled: true,
    language: 'Indonesia',
    appVersion: '2.4.0 (Kabupaten X)',
  );

  static final List<FacilityModel> facilities = [
    FacilityModel(
      id: 'rsud-x',
      name: 'RSUD Kabupaten X',
      category: 'rumah-sakit',
      categoryLabel: 'Rumah Sakit',
      typeDetail: 'RS Rujukan Utama',
      address: 'Jl. Raya Puncak - Gadog No. 479',
      addressDetail:
          'Jl. Raya Puncak - Gadog No. 479, Bendungan, Kec. Ciawi, Kab. Bogor 16720\nAkses cepat lewat Jalur Utama Puncak & IGD Siaga 24 Jam Nonstop',
      distanceKm: 1.2,
      travelTime: '4 menit (1.2 km)',
      rating: 4.8,
      reviewCount: 420,
      isOpen: true,
      openStatusText: 'Buka 24 Jam',
      operatingHours: 'Setiap Hari • 24 Jam Nonstop',
      isIgdAvailable: true,
      isBpjsAvailable: true,
      services: ['IGD', 'Poliklinik', 'Rawat Inap', 'Laboratorium'],
      photoUrl:
          'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=600&q=80',
      phoneEmergency: '(0251) 8240797',
      phoneInfo: '(0251) 8240798',
      latitude: -6.6578,
      longitude: 106.8488,
      mapXPercent: 0.22,
      mapYPercent: 0.19,
      pinColor: const Color(0xFFDC2626),
      accreditation: 'RSUD Tipe B Terakreditasi Paripurna KARS',
      isFavorite: true,
    ),
    FacilityModel(
      id: 'puskesmas-sukamaju',
      name: 'Puskesmas Sukamaju',
      category: 'puskesmas',
      categoryLabel: 'Puskesmas',
      typeDetail: 'Puskesmas Pembina',
      address: 'Jl. Raya Ciawi - Sukabumi No. 12',
      addressDetail:
          'Jl. Raya Ciawi - Sukabumi No. 12, Desa Sukamaju, Kec. Ciawi, Kab. Bogor\nPelayanan rawat jalan, persalinan, dan terintegrasi posyandu desa',
      distanceKm: 0.5,
      travelTime: '3 menit (500 m)',
      rating: 4.6,
      reviewCount: 180,
      isOpen: true,
      openStatusText: 'Buka s/d 16:00',
      operatingHours: 'Senin - Sabtu • 08:00 - 16:00 WIB',
      isIgdAvailable: true,
      isBpjsAvailable: true,
      services: ['Umum', 'KIA', 'Imunisasi', 'Laboratorium'],
      photoUrl:
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=600&q=80',
      phoneEmergency: '(0251) 8241122',
      phoneInfo: '(0251) 8241123',
      latitude: -6.6625,
      longitude: 106.8430,
      mapXPercent: 0.74,
      mapYPercent: 0.25,
      pinColor: const Color(0xFF059669),
      accreditation: 'Puskesmas Paripurna Kemenkes RI',
      isFavorite: false,
    ),
    FacilityModel(
      id: 'klinik-sehat-mandiri',
      name: 'Klinik Sehat Mandiri',
      category: 'klinik',
      categoryLabel: 'Klinik',
      typeDetail: 'Klinik Pratama',
      address: 'Jl. Veteran III No. 88',
      addressDetail:
          'Komplek Ruko Veteran Indah No. 88, Banjarsari, Kec. Ciawi, Kab. Bogor',
      distanceKm: 2.1,
      travelTime: '6 menit (2.1 km)',
      rating: 4.7,
      reviewCount: 95,
      isOpen: true,
      openStatusText: 'Buka s/d 21:00',
      operatingHours: 'Senin - Minggu • 07:00 - 21:00 WIB',
      isIgdAvailable: false,
      isBpjsAvailable: true,
      services: ['Umum', 'Gigi', 'Laboratorium'],
      photoUrl:
          'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=600&q=80',
      phoneEmergency: '(0251) 8243344',
      phoneInfo: '(0251) 8243344',
      latitude: -6.6515,
      longitude: 106.8520,
      mapXPercent: 0.28,
      mapYPercent: 0.68,
      pinColor: const Color(0xFF1A73E8),
      accreditation: 'Klinik Pratama Terakreditasi Kemenkes',
      isFavorite: false,
    ),
    FacilityModel(
      id: 'rs-harapan-bunda',
      name: 'RS Harapan Bunda',
      category: 'rumah-sakit',
      categoryLabel: 'Rumah Sakit',
      typeDetail: 'RS Swasta Terpadu',
      address: 'Jl. Raya Tajur No. 168',
      addressDetail:
          'Jl. Raya Tajur No. 168, Muarasari, Kec. Bogor Selatan / Ciawi, Kab. Bogor',
      distanceKm: 3.4,
      travelTime: '10 menit (3.4 km)',
      rating: 4.7,
      reviewCount: 115,
      isOpen: true,
      openStatusText: 'Buka 24 Jam',
      operatingHours: 'Setiap Hari • 24 Jam Nonstop',
      isIgdAvailable: true,
      isBpjsAvailable: false,
      services: ['IGD', 'Poliklinik', 'Rawat Inap', 'Radiologi'],
      photoUrl:
          'https://images.unsplash.com/photo-1512678080530-7760d81faba6?auto=format&fit=crop&w=600&q=80',
      phoneEmergency: '(0251) 8328888',
      phoneInfo: '(0251) 8328880',
      latitude: -6.6430,
      longitude: 106.8390,
      mapXPercent: 0.78,
      mapYPercent: 0.72,
      pinColor: const Color(0xFFDC2626),
      accreditation: 'RS Tipe C Paripurna KARS',
      isFavorite: false,
    ),
  ];

  static final List<ServiceItemModel> hospitalServices = [
    const ServiceItemModel(
      id: 'poli',
      name: 'Poliklinik Spesialis',
      shortName: 'Poliklinik',
      subtitle: '14 Poli',
      description:
          'Melayani 14 bidang spesialisasi: Anak, Penyakit Dalam, Bedah, Kandungan, THT, Mata, Saraf, Jantung, Kulit, dan Gigi Mulut.',
      icon: Icons.medical_services_outlined,
      availableStatus: 'Senin - Sabtu (08:00 - 15:00)',
    ),
    const ServiceItemModel(
      id: 'igd',
      name: 'Instalasi Gawat Darurat (IGD)',
      shortName: 'IGD 24J',
      subtitle: 'Siaga',
      description:
          'Pelayanan triase gawat darurat 24 jam dengan dokter spesialis emergensi, ruang resusitasi, dan ruang isolasi khusus.',
      icon: Icons.emergency_outlined,
      isEmergency: true,
      availableStatus: '24 Jam Siaga Nonstop',
    ),
    const ServiceItemModel(
      id: 'inap',
      name: 'Rawat Inap',
      shortName: 'Rawat Inap',
      subtitle: '210 Bed',
      description:
          'Kapasitas 210 tempat tidur: VVIP, VIP, Kelas 1, 2, 3, HCU, ICCU, dan ICU terakreditasi paripurna BPJS.',
      icon: Icons.hotel_outlined,
      availableStatus: 'Tersedia Setiap Hari',
    ),
    const ServiceItemModel(
      id: 'lab',
      name: 'Laboratorium Klinis',
      shortName: 'Laborat',
      subtitle: 'Akreditasi A',
      description:
          'Pemeriksaan hematologi lengkap, kimia klinik, mikrobiologi, serologi, dan skrining molekuler dengan hasil cepat terintegrasi sistem.',
      icon: Icons.biotech_outlined,
      availableStatus: '24 Jam Melayani',
    ),
    const ServiceItemModel(
      id: 'rad',
      name: 'Radiologi & Imaging',
      shortName: 'Radiologi',
      subtitle: 'CT & USG',
      description:
          'Fasilitas diagnostik modern: CT-Scan 128 Slices, USG 4D, X-Ray Digital, Mammografi, dan Panoramic Dental.',
      icon: Icons.monitor_heart_outlined,
      availableStatus: '24 Jam Melayani',
    ),
    const ServiceItemModel(
      id: 'farmasi',
      name: 'Instalasi Farmasi',
      shortName: 'Farmasi',
      subtitle: '24 Jam',
      description:
          'Pelayanan tebus resep rawat jalan, rawat inap, dan konsultasi obat bersama apoteker terdaftar selama 24 jam.',
      icon: Icons.medication_outlined,
      availableStatus: '24 Jam Nonstop',
    ),
    const ServiceItemModel(
      id: 'rehab',
      name: 'Rehabilitasi Medik',
      shortName: 'Rehabilitasi',
      subtitle: 'Fisioterapi',
      description:
          'Fisioterapi pasca-stroke, terapi wicara, terapi okupasi, dan pemulihan cedera fisik dipandu dokter spesialis KFR.',
      icon: Icons.accessibility_new_outlined,
      availableStatus: 'Senin - Jumat (08:00 - 16:00)',
    ),
    const ServiceItemModel(
      id: 'lainnya',
      name: 'Layanan Penunjang Lainnya',
      shortName: 'Lainnya',
      subtitle: 'BDRS & MCU',
      description:
          'Ambulans Siaga 24 Jam, Bank Darah Rumah Sakit (BDRS), Kamar Jenazah Medis, Konseling Gizi, dan MCU Eksekutif.',
      icon: Icons.more_horiz_outlined,
      availableStatus: 'Tersedia Terpadu',
    ),
  ];
}

