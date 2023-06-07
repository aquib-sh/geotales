class UserFile {
  final String id;
  final String userId;
  final String userEmail;
  final String fileName;
  final String fileType;
  final double latitude;
  final double longitude;
  final DateTime uploadTimestamp;
  final String base64Image;

  UserFile({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.fileName,
    required this.fileType,
    required this.latitude,
    required this.longitude,
    required this.uploadTimestamp,
    required this.base64Image,
  });

  factory UserFile.fromJson(Map<String, dynamic> json) {
    return UserFile(
      id: json['id'],
      userId: json['userId'],
      userEmail: json['userEmail'],
      fileName: json['fileName'],
      fileType: json['fileType'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      uploadTimestamp: DateTime.parse(json['uploadTimestamp']),
      base64Image: json['base64Image'],
    );
  }
}
