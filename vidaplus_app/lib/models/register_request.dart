enum UserRole { ADMIN, PACIENTE, PROFISSIONAL }

class RegisterRequest {
  final String nome;
  final String email;
  final String senha;
  final UserRole perfil;
  final String? especialidadeId;
  final String? registro;

  RegisterRequest({
    required this.nome,
    required this.email,
    required this.senha,
    required this.perfil,
    this.especialidadeId,
    this.registro,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nome': nome,
      'email': email,
      'senha': senha,
      'perfil': perfil.name,
    };
    if (especialidadeId != null) {
      data['especialidadeId'] = especialidadeId;
    }
    if (registro != null) {
      data['registro'] = registro;
    }
    return data;
  }
}