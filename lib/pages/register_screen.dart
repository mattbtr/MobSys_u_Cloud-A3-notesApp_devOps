import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RegisterScreen({super.key});

  // Registrierungs-Logik (Funktion)
  void register(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        );

         if (!context.mounted) return; // schützt vor ungültigem Kontext

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Resistration failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(title: const Text('Register'),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child : Column(
          children: [

            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'E-Mail'),),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Passowrd'),),

            const SizedBox(height: 16,),

            // Register-Button: Bei Drücken wird Register-Funktion von oben ausgeführt
            ElevatedButton(onPressed: () => register(context), child: const Text("Register"))
            
          ],
        )
      )
    );
  }

}