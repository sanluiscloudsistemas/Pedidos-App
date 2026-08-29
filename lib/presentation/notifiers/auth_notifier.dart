import 'package:flutter/material.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/check_session_use_case.dart';
import '../../domain/entities/user_entity.dart';

class AuthNotifier extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final CheckSessionUseCase _checkSessionUseCase;

  AuthNotifier(this._loginUseCase, this._checkSessionUseCase);

  bool _isLoading = false;
  String? _errorMessage;
  UserEntity? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserEntity? get currentUser => _currentUser;

  // Mantengo getter authResponse por compatibilidad con LoginScreen existente
  UserEntity? get authResponse => _currentUser;

  Future<bool> login(String organizacion, String usuario, String contrasenia) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _loginUseCase.execute(
        organizacion: organizacion,
        usuario: usuario,
        contrasenia: contrasenia,
      );

      _isLoading = false;
      if (_currentUser == null) {
        _errorMessage = 'Credenciales inválidas o sesión no iniciada';
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _checkSessionUseCase.execute();
      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
