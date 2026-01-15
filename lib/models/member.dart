class Member {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String status;
  final String? nickName;
  final String? department;
  final String? hall;
  final String? batch;
  final String? currentLocation;
  final String? currentOrganization;
  final String? currentPosition;
  final String? phone;
  final String? bloodGroup;
  final String? photoUrl;
  final String? dateOfBirth;
  final String createdAt;

  Member({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.status,
    this.nickName,
    this.department,
    this.hall,
    this.batch,
    this.currentLocation,
    this.currentOrganization,
    this.currentPosition,
    this.phone,
    this.bloodGroup,
    this.photoUrl,
    this.dateOfBirth,
    required this.createdAt,
  });

  factory Member.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Member(
      id: documentId,
      userId: data['user_id'] ?? documentId,
      fullName: data['full_name'] ?? '',
      email: data['email'] ?? '',
      status: data['status'] ?? 'pending',
      nickName: data['nick_name'],
      department: data['department'],
      hall: data['hall'],
      batch: data['batch'],
      currentLocation: data['current_location'],
      currentOrganization: data['current_organization'],
      currentPosition: data['current_position'],
      phone: data['phone'],
      bloodGroup: data['blood_group'],
      photoUrl: data['photo_url'],
      dateOfBirth: data['date_of_birth'],
      createdAt: data['created_at'] ?? '',
    );
  }

  // Always return full name
  String get displayName => fullName;
  
  String get location => currentLocation ?? 'Location not specified';
  
  String get organization => currentOrganization ?? 'Organization not specified';
  
  String get position => currentPosition ?? 'Position not specified';
}
