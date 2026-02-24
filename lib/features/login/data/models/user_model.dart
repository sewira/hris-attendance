class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String token;
  final String role;
  bool isNewEmployee;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.token,
    required this.role,
    required this.isNewEmployee,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return UserModel(
      id: data["id"],
      fullName: data["full_name"],
      email: data["email"],
      token: data["token"],
      role: data["role"],
      isNewEmployee: data["is_new_employee"] ?? false,
    );
  }
}