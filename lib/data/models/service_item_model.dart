import 'package:flutter/material.dart';

class ServiceItemModel {
  final String id;
  final String name;
  final String shortName;
  final String subtitle;
  final String description;
  final IconData icon;
  final bool isEmergency;
  final String availableStatus;

  const ServiceItemModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.subtitle,
    required this.description,
    required this.icon,
    this.isEmergency = false,
    this.availableStatus = 'Tersedia Setiap Hari',
  });
}

