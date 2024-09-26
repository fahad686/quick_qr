class UserModel {
  final String uid;
  final String email;
  final String name;
  final String profileImageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }
}
