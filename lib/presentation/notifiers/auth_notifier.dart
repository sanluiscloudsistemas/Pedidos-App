import 'package:flutter/material.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/check_session_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/login_with_biometrics_use_case.dart';
import '../../domain/entities/user_entity.dart';

class AuthNotifier extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final CheckSessionUseCase _checkSessionUseCase;
  final LogoutUseCase? _logoutUseCase;
  final LoginWithBiometricsUseCase? _loginWithBiometricsUseCase;

  AuthNotifier(
    this._loginUseCase,
    this._checkSessionUseCase, [
    this._logoutUseCase,
    this._loginWithBiometricsUseCase,
  ]);

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
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithBiometrics() async {
    if (_loginWithBiometricsUseCase == null) {
      _errorMessage = 'Biometría no configurada';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _loginWithBiometricsUseCase.execute();
      _isLoading = false;
      if (_currentUser == null) {
        notifyListeners();
        return false;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> canUseBiometrics() async {
    if (_loginWithBiometricsUseCase == null) return false;
    try {
      return await _loginWithBiometricsUseCase.canUseBiometrics();
    } catch (_) {
      return false;
    }
  }

  Future<bool> isBiometricAvailable() async {
    if (_loginWithBiometricsUseCase == null) return false;
    try {
      return await _loginWithBiometricsUseCase.isBiometricAvailable();
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, String>?> getSavedUserData() async {
    try {
      return await _checkSessionUseCase.getSavedUserData();
    } catch (_) {
      return null;
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
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _logoutUseCase?.execute();
    } catch (_) {}
    _currentUser = null;
    notifyListeners();
  }
}

