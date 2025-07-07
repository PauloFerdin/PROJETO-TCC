import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/paciente.dart';
import '../models/profissional.dart';
import 'auth_service.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthManager extends ChangeNotifier {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();
  static AuthManager get instance => _instance;

  final AuthService _apiService = AuthService();

  bool _isLoading = true;
  bool _isLoggedIn = false;
  String? _userRole;
  Usuario? _usuario;
  String? _token;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get userRole => _userRole;
  Usuario? get usuario => _usuario;
  String? get token => _token;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');

    if (_token != null && _token!.isNotEmpty) {
      _isLoggedIn = true;
      _userRole = prefs.getString('perfil');
      final userInfoString = prefs.getString('usuario_info');
      if (userInfoString != null) {
        _usuario = Usuario.fromJson(jsonDecode(userInfoString));
      }
    }
    _isLoading = false;
  }

  Future<void> login(String email, String senha) async {
    final request = LoginRequest(email: email, senha: senha);

    try {
      final response = await _apiService.login(request);

      _isLoggedIn = true;
      _userRole = response.user.perfil;
      _usuario = response.user;
      _token = response.token;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('perfil', _userRole!);
      await prefs.setString('usuario_info', jsonEncode(response.user.toJson()));

      notifyListeners();
    } catch (e) {
      print("Erro capturado no AuthManager: $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _userRole = null;
    _usuario = null;
    _token = null;
    notifyListeners();
  }

  void updatePacienteInfo(Paciente pacienteAtualizado) {
    if (_usuario != null) {
      _usuario = Usuario(
        id: _usuario!.id,
        nome: _usuario!.nome,
        email: _usuario!.email,
        perfil: _usuario!.perfil,
        paciente: pacienteAtualizado,
        profissional: _usuario!.profissional,

      );
      notifyListeners();
    }
  }

  void updateProfissionalInfo(Profissional profissionalAtualizado) {
    if (_usuario != null) {
      _usuario = Usuario(
        id: _usuario!.id,
        nome: _usuario!.nome,
        email: _usuario!.email,
        perfil: _usuario!.perfil,
        paciente: _usuario!.paciente,
        profissional: profissionalAtualizado,
      );
      notifyListeners();
    }
  }
}