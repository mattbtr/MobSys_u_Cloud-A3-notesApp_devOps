import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_empty_application_1/pages/login_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('Login zeigt Fehler bei falschen Zugangsdaten', (
      WidgetTester tester,
    ) async {
      // Erstelle einen Mock ohne registrierte User
      final mockAuth = MockFirebaseAuth();

      // Baue das Widget mit dem Mock statt echtem FirebaseAuth
      await tester.pumpWidget(MaterialApp(home: LoginScreen(auth: mockAuth)));

      // Eingabe simulieren
      await tester.enterText(find.byType(TextField).first, 'test@test.com');
      await tester.enterText(find.byType(TextField).last, 'wrongpassword');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Erwartung: Fehler-Snackbar wird angezeigt
      expect(find.textContaining('Login failed'), findsOneWidget);
    });

    testWidgets('Login mit gültigen Zugangsdaten', (WidgetTester tester) async {
      // Benutzer anlegen
      final user = MockUser(
        isAnonymous: false,
        email: 'test@example.com',
        uid: 'abc123',
      );
      final mockAuth = MockFirebaseAuth(mockUser: user);

      // Registriere den Benutzer vorher
      await mockAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: '123456',
      );

      await tester.pumpWidget(MaterialApp(home: LoginScreen(auth: mockAuth)));

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, '123456');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Erfolg: keine Fehlermeldung, Snackbar wird **nicht** gezeigt
      expect(find.textContaining('Login failed'), findsNothing);
    });
  });
}
