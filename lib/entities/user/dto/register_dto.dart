class RegisterDTO {
  String name = '';
  String username = '';
  String email = '';
  String password = '';

  RegisterDTO({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
