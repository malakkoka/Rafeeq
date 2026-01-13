class PatientModel {
  final int id;
  final String username;
  final String userType;
  final bool canWrite;
  final bool canSpeakWithSignLanguage;

  PatientModel({
    required this.id,
    required this.username,
    required this.userType,
    required this.canWrite,
    required this.canSpeakWithSignLanguage,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      username: json['username'],
      userType: json['user_type'],
      canWrite: json['can_write'],
      canSpeakWithSignLanguage: json['can_speak_with_sign_language'],
    );
  }

  /// تحويل النوع لنص مفهوم بالواجهة
  String get displayDisability {
    if (userType == 'blind') return 'Blind User';
    if (userType == 'deaf') return 'Deaf User';

    return 'User with Disability';
  }
}
