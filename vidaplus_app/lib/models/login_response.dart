import 'paciente.dart';
import 'profissional.dart';

class LoginResponse {
  final String token;
  final Usuario user; // O nome da propriedade aqui é 'user'

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      // O nome da chave no JSON é 'user', então usamos json['user']
      user: Usuario.fromJson(json['user']),
    );
  }
}

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String perfil;
  final Paciente? paciente;
  final Profissional? profissional;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
    this.paciente,
    this.profissional,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      perfil: json['perfil'],
      paciente: json['paciente'] != null
          ? Paciente.fromJson(json['paciente'])
          : null,
      profissional: json['profissional'] != null
          ? Profissional.fromJson(json['profissional'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'perfil': perfil,
      'paciente': paciente?.toJson(),
      'profissional': profissional?.toJson(),
    };
  }
}