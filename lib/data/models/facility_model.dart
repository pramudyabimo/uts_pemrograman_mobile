import 'package:flutter/material.dart';

class FacilityModel {
  final String id;
  final String name;
  final String category; // 'rumah-sakit', 'puskesmas', 'klinik'
  final String categoryLabel; // 'Rumah Sakit', 'Puskesmas', 'Klinik'
  final String typeDetail; // 'RS Rujukan Utama', 'Puskesmas', 'Klinik Pratama', 'RS Swasta'
  final String address;
  final String addressDetail;
  final double distanceKm;
  final String travelTime;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final String openStatusText;
  final String operatingHours;
  final bool isIgdAvailable;
  final bool isBpjsAvailable;
  final List<String> services;
  final String photoUrl;
  final String phoneEmergency;
  final String phoneInfo;
  final double latitude;
  final double longitude;
  final double mapXPercent; // for relative SVG canvas pin positioning
  final double mapYPercent;
  final Color pinColor;
  final String accreditation;
  bool isFavorite;

  FacilityModel({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.typeDetail,
    required this.address,
    required this.addressDetail,
    required this.distanceKm,
    required this.travelTime,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    required this.openStatusText,
    required this.operatingHours,
    required this.isIgdAvailable,
    required this.isBpjsAvailable,
    required this.services,
    required this.photoUrl,
    required this.phoneEmergency,
    required this.phoneInfo,
    required this.latitude,
    required this.longitude,
    required this.mapXPercent,
    required this.mapYPercent,
    required this.pinColor,
    required this.accreditation,
    this.isFavorite = false,
  });

  String get distanceString => '${distanceKm.toStringAsFixed(1)} km';
}

