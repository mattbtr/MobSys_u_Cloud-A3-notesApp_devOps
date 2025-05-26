import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_empty_application_1/pages/register_screen.dart';

void main() {
  group('RegisterScreen', () {
    testWidgets('zeigt Fehlermeldung bei bereits registrierter E-Mail', (
      WidgetTester tester,
    ) async {
      // Ein MockAuth mit bereits registriertem User
      final mockUser = MockUser(email: 'test@example.com');
      final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: false);
      await mockAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      await tester.pumpWidget(
        MaterialApp(home: RegisterScreen(auth: mockAuth)),
      );

      // Eingabe simulieren
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Der zweite Registrierversuch mit gleicher E-Mail sollte fehlschlagen
      expect(find.textContaining('E-Mail is already in use.'), findsOneWidget);
    });

    testWidgets('erfolgreiche Registrierung zeigt keine Fehlermeldung', (
      WidgetTester tester,
    ) async {
      final mockAuth = MockFirebaseAuth();

      await tester.pumpWidget(
        MaterialApp(home: RegisterScreen(auth: mockAuth)),
      );

      // Eingabe simulieren
      await tester.enterText(
        find.byType(TextField).at(0),
        'newuser@example.com',
      );
      await tester.enterText(find.byType(TextField).at(1), 'newpassword');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Keine Fehlermeldung sollte angezeigt werden
      expect(find.textContaining('Registration failed'), findsNothing);
    });
  });
}
