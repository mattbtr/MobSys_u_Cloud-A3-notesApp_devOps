import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_empty_application_1/utils/validator.dart'; // Pfad ggf. anpassen

void main() {
  group('Validator', () {
    test('leere E-Mail wird erkannt', () {
      expect(Validator.validateEmail(''), 'E-Mail darf nicht leer sein');
    });

    test('ungültige E-Mail wird erkannt', () {
      expect(
        Validator.validateEmail('invalidemail'),
        'Ungültige E-Mail-Adresse',
      );
    });

    test('gültige E-Mail wird akzeptiert', () {
      expect(Validator.validateEmail('test@example.com'), isNull);
    });

    test('leeres Passwort wird erkannt', () {
      expect(Validator.validatePassword(''), 'Passwort darf nicht leer sein');
    });

    test('zu kurzes Passwort wird erkannt', () {
      expect(
        Validator.validatePassword('123'),
        'Passwort muss mindestens 6 Zeichen lang sein',
      );
    });

    test('gültiges Passwort wird akzeptiert', () {
      expect(Validator.validatePassword('geheim123'), isNull);
    });
  });
}
