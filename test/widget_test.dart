import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:preventa/domain/entities/user_entity.dart';
import 'package:preventa/domain/repositories/auth_repository.dart';
import 'package:preventa/domain/usecases/login_use_case.dart';
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
      session: 'fake_session',
      usuario: usuario,
      organizacion: organizacion,
    );
  }

  @override
  Future<UserEntity?> getCurrentUser() async => null;

  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('Carga de pantalla de login smoke test', (WidgetTester tester) async {
    final fakeRepo = FakeAuthRepository();
    final loginUseCase = LoginUseCase(fakeRepo);
    final authNotifier = AuthNotifier(loginUseCase);

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
