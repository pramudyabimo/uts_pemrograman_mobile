class UserProfileModel {
  final String name;
  final String phone;
  final String nik;
  final bool isNikVerified;
  final String location;
  final String avatarUrl;
  final bool emergencyAlertsEnabled;
  final String language;
  final String appVersion;

  const UserProfileModel({
    required this.name,
    required this.phone,
    required this.nik,
    required this.isNikVerified,
    required this.location,
    required this.avatarUrl,
    required this.emergencyAlertsEnabled,
    required this.language,
    required this.appVersion,
  });
}

