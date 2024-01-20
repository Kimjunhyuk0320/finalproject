class User {
  String? username;
  String? password;
  String? name;
  String? nickname;
  String? phone;
  String? email;
  String? auth;

  User({
    this.username,
    this.password,
    this.name,
    this.nickname,
    this.phone,
    this.email,
    this.auth,
  });

  // 회원가입을 위해
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'nickname': nickname,
      'phone': phone,
      'email': email,
      'auth': auth,
    };
  }
}
