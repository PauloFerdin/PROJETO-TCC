class LoginRequest {
  final String email;
  final String senha;

  LoginRequest({required this.email, required this.senha});

  Map<String, dynamic> toJson() => {
    'email': email,
    'senha': senha,
  };
}
