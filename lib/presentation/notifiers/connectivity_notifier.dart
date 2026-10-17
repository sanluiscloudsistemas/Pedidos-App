import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Notificador de estado de conectividad a Internet en tiempo real.
/// Escucha cambios de red (Wi-Fi, Datos Móviles, Ethernet, Offline)
/// y notifica a los widgets (como PreventaAppBar) para actualizar la UI en vivo.
class ConnectivityNotifier extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isConnected = true;
  bool _isManualOverride = false;
  bool _manualOfflineState = false;

  bool get isConnected {
    // La simulación manual solo se encuentra habilitada en entornos de desarrollo / pruebas (kDebugMode)
    if (kDebugMode && _isManualOverride) {
      return !_manualOfflineState;
    }
    return _isConnected;
  }

  ConnectivityNotifier() {
    _initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (_) {
      _isConnected = true;
      notifyListeners();
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Si no hay ningún resultado o contiene exclusivamente 'none', no hay conexión.
    final hasNoConnection = results.isEmpty ||
        results.contains(ConnectivityResult.none);
    _isConnected = !hasNoConnection;
    notifyListeners();
  }

  /// Alternar simulación manual de estado Online/Offline (solo disponible en modo Debug)
  void toggleManualSimulatedState() {
    if (!kDebugMode) return;
    _isManualOverride = true;
    _manualOfflineState = !_manualOfflineState;
    notifyListeners();
  }

  /// Restablecer la detección automática de red
  void resetToRealConnectivity() {
    _isManualOverride = false;
    _initConnectivity();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
