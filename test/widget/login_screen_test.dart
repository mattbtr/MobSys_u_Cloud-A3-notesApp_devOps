import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_empty_application_1/pages/login_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('Login zeigt Fehler bei falschen Zugangsdaten', (
      WidgetTester tester,
    ) async {
      //final mockAuth = MockFirebaseAuth();

      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Eingabe simulieren
      await tester.enterText(find.byType(TextField).first, 'test@test.com');  //erste TextField (E-Mail)
      await tester.enterText(find.byType(TextField).last, 'wrongpassword');   //zweite TextField (Passwort)
      // Tippen auf den Login-Button
      await tester.tap(find.byType(ElevatedButton));
      //Wartet, bis alle Animationen und asynchrone Vorgänge abgeschlossen sind
      await tester.pumpAndSettle();

      // Kein Login möglich mit Mock (kein registrierte User) => Fehlermeldung
      expect(find.textContaining('Login failed'), findsOneWidget);
    });
  });
}
