class UserModel {
  final String name;
  final String email;
  final bool isAdmin;

  UserModel({required this.name, required this.email, required this.isAdmin});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['username'] ?? '',
      email: map['email'] ?? '',
      isAdmin: bool.tryParse((map['is_admin'] ?? false).toString()) ?? false,
    );
  }
}
