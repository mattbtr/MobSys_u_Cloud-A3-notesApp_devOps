import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_empty_application_1/pages/add_notes_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  group('AddNoteScreen', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'test-user', email: 'test@user.com'),
        signedIn: true,
      );
    });

    testWidgets('Neue Notiz wird gespeichert', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: AddNoteScreen(firestore: firestore, auth: auth)),
      );

      await tester.enterText(find.byType(TextField), 'Test-Notiz');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final notes = await firestore.collection('notes').get();
      expect(notes.docs.length, 1);
      expect(notes.docs.first['text'], 'Test-Notiz');

      // Zurück zur vorherigen Seite
      expect(find.byType(AddNoteScreen), findsNothing);
    });

    testWidgets('Vorhandene Notiz wird bearbeitet', (
      WidgetTester tester,
    ) async {
      final noteRef = await firestore.collection('notes').add({
        'text': 'Alte Notiz',
        'userId': 'test-user',
        'timestamp': DateTime.now(),
      });

      await tester.pumpWidget(
        MaterialApp(
          home: AddNoteScreen(
            firestore: firestore,
            auth: auth,
            existingNoteId: noteRef.id,
            initialText: 'Alte Notiz',
          ),
        ),
      );

      expect(find.text('Alte Notiz'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Bearbeitete Notiz');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final updatedNote =
          await firestore.collection('notes').doc(noteRef.id).get();
      expect(updatedNote['text'], 'Bearbeitete Notiz');

      expect(find.byType(AddNoteScreen), findsNothing);
    });
  });
}
