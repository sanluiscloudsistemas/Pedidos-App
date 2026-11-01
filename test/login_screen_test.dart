import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:preventa/domain/entities/user_entity.dart';
import 'package:preventa/domain/repositories/auth_repository.dart';
import 'package:preventa/domain/usecases/check_session_use_case.dart';
import 'package:preventa/domain/usecases/login_use_case.dart';
import 'package:preventa/domain/usecases/login_with_biometrics_use_case.dart';
import 'package:preventa/domain/usecases/logout_use_case.dart';
import 'package:preventa/presentation/notifiers/auth_notifier.dart';
import 'package:preventa/presentation/screens/login_screen.dart';

class MockAuthRepository implements AuthRepository {
  String? lastOrganizacion;
  String? lastUsuario;
  String? lastContrasenia;

  @override
  Future<UserEntity?> login({
    required String organizacion,
    required String usuario,
    required String contrasenia,
  }) async {
    lastOrganizacion = organizacion;
    lastUsuario = usuario;
    lastContrasenia = contrasenia;
    return UserEntity(
      token: 'mock_token',
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
  testWidgets('Muestra campo Organización cuando SISORG_CODIGO no está definido',
      (WidgetTester tester) async {
    dotenv.loadFromString(envString: '', isOptional: true);

    final mockRepo = MockAuthRepository();
    final authNotifier = AuthNotifier(
      LoginUseCase(mockRepo),
      CheckSessionUseCase(mockRepo),
      LogoutUseCase(mockRepo),
      LoginWithBiometricsUseCase(mockRepo),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthNotifier>.value(
        value: authNotifier,
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Organización'), findsOneWidget);
  });

  testWidgets(
      'Oculta campo Organización y usa valor de SISORG_CODIGO cuando está definido',
      (WidgetTester tester) async {
    dotenv.loadFromString(envString: 'SISORG_CODIGO=CTRO\n');

    final mockRepo = MockAuthRepository();
    final authNotifier = AuthNotifier(
      LoginUseCase(mockRepo),
      CheckSessionUseCase(mockRepo),
      LogoutUseCase(mockRepo),
      LoginWithBiometricsUseCase(mockRepo),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthNotifier>.value(
        value: authNotifier,
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // El campo no debe estar visible
    expect(find.text('Organización'), findsNothing);

    // Llenamos usuario y contraseña y enviamos
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Usuario'), 'VENDEDOR1');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña'), '123456');

    await tester.tap(find.text('Conectar'));
    await tester.pumpAndSettle();

    // Debe haber ejecutado login con la organización configurada en dotenv
    expect(mockRepo.lastOrganizacion, equals('CTRO'));
    expect(mockRepo.lastUsuario, equals('VENDEDOR1'));
  });
}
