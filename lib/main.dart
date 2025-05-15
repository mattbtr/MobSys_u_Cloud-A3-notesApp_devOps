import 'package:flutter/material.dart';   // import für Design UI-Toolkit von Flutter (Widgets, Themes etc.)
import 'package:flutter_empty_application_1/pages/auth_logic.dart';   // import der Authentication-Logik (zeigt Login oder HomeScrenn je Auth.status)
//import 'pages/home_screen.dart';
//import 'pages/add_notes_screen.dart';
import 'package:firebase_core/firebase_core.dart';  // Firebase Core Package für Firebase App in Flutter
import 'firebase_options.dart';   // enthält Firebase-Prohjekt-Konfiguration


void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  // Sorgt dafür, dass alle Widgets und Dienste bevor Firebase initialisiert wird.
  // Wichtig bei asynchronem Code wie Firebase.initializeApp() 
  await Firebase.initializeApp(         // Firebase Projekt initialisieren
    options: DefaultFirebaseOptions.currentPlatform,
    // Verwendet die automatisch generierte Konfiguration aus firebase_options.dart
    // (enthält u. a. API-Key, Projekt-ID etc.)
);

runApp(const MainApp());

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentification',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),   // Aktiviert das neuere Material Design 3 (MD3), primäre Theme-Farben
      home: AuthLogic(), // Startbildschirm ist die Authentifizierung
    );
  }
}
