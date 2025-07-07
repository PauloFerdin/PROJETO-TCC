import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AppAuthService extends ChangeNotifier {
  final AuthService _apiService = AuthService();

  bool _isLoggedIn = false;
  String? _userRole;
  String? _token;
  bool _isLoading = true;

  bool get isLoggedIn => _isLoggedIn;
  String? get userRole => _userRole;
  String? get token => _token;
  bool get isLoading => _isLoading;

  AppAuthService() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');

    if (storedToken != null && storedToken.isNotEmpty) {
      _isLoggedIn = true;
      _userRole = prefs.getString('perfil');
      _token = storedToken;
    } else {
      _isLoggedIn = false;
      _userRole = null;
      _token = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String senha) async {
    try {
      final request = LoginRequest(email: email, senha: senha);

      final response = await _apiService.login(request);

      if (response != null) {
        _isLoggedIn = true;
        _token = response.token;
        _userRole = response.user.perfil;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('perfil', _userRole!);

        notifyListeners();
      }
    } catch (e) {
      print("Erro no AppAuthService: $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _userRole = null;
    _token = null;
    notifyListeners();
  }
}