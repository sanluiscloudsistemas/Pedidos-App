import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:preventa/domain/entities/user_entity.dart';
import 'package:preventa/domain/repositories/auth_repository.dart';
import 'package:preventa/domain/usecases/login_use_case.dart';
import 'package:preventa/domain/usecases/check_session_use_case.dart';
import 'package:preventa/domain/usecases/logout_use_case.dart';
import 'package:preventa/domain/usecases/login_with_biometrics_use_case.dart';
import 'package:preventa/presentation/notifiers/auth_notifier.dart';
import 'package:preventa/presentation/screens/login_screen.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<UserEntity?> login({
    required String organizacion,
    required String usuario,
    required String contrasenia,
  }) async {
    return UserEntity(
      token: 'fake_session',
      usuario: usuario,
      organizacion: organizacion,
    );
  }

  @override
  Future<UserEntity?> loginWithBiometrics() async => null;

  @override
  Future<UserEntity?> getCurrentUser() async => null;

  @override
  Future<void> logout() async {}

  @override
  Future<void> setBiometricEnabled(bool enabled) async {}

  @override
  Future<bool> isBiometricEnabled() async => false;

  @override
  Future<bool> isBiometricAvailable() async => false;

  @override
  Future<bool> canUseBiometrics() async => false;

  @override
  Future<Map<String, String>?> getSavedUserData() async => null;
}

void main() {
  testWidgets('Carga de pantalla de login smoke test', (WidgetTester tester) async {
    final fakeRepo = FakeAuthRepository();
    final loginUseCase = LoginUseCase(fakeRepo);
    final checkSessionUseCase = CheckSessionUseCase(fakeRepo);
    final logoutUseCase = LogoutUseCase(fakeRepo);
    final loginWithBiometricsUseCase = LoginWithBiometricsUseCase(fakeRepo);
    final authNotifier = AuthNotifier(
      loginUseCase,
      checkSessionUseCase,
      logoutUseCase,
      loginWithBiometricsUseCase,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthNotifier>.value(
        value: authNotifier,
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Ingreso Preventas'), findsOneWidget);
    expect(find.text('Organización'), findsOneWidget);
  });
}
