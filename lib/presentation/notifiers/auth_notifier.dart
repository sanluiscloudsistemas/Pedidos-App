import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/dto/auth_response_dto.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  AuthResponse? _authResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;

  Future<bool> login(String organizacion, String usuario, String contrasenia) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _authResponse = await _authRepository.login(organizacion, usuario, contrasenia);
      
      if (_authResponse?.resultado == 'ERROR') { // Suponiendo un string de resultado
        _errorMessage = 'Credenciales inválidas';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _authResponse = null;
    notifyListeners();
  }
}
