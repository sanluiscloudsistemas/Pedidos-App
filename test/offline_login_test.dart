import 'package:flutter_test/flutter_test.dart';
import 'package:preventa/core/utils/hash_util.dart';

void main() {
  group('Pruebas de Hash y Autenticación Offline', () {
    test('HashUtil genera hash SHA-256 consistente', () {
      final hash1 = HashUtil.hashCredentials('ORG1', 'USER1', 'Pass123!');
      final hash2 = HashUtil.hashCredentials('ORG1', 'USER1', 'Pass123!');
      final hashDiff = HashUtil.hashCredentials('ORG1', 'USER1', 'WrongPass');

      expect(hash1, isNotEmpty);
      expect(hash1, equals(hash2));
      expect(hash1, isNot(equals(hashDiff)));
    });

    test('HashUtil normaliza mayúsculas en Organización y Usuario', () {
      final hashUpper = HashUtil.hashCredentials('ORG1', 'USER1', 'Pass123!');
      final hashLower = HashUtil.hashCredentials('org1', 'user1', 'Pass123!');

      expect(hashUpper, equals(hashLower));
    });
  });
}
