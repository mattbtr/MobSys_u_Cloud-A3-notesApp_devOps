import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddNoteScreen extends StatefulWidget {
  final String? existingNoteId;
  final String? initialText;

  const AddNoteScreen({
    super.key,
    this.existingNoteId,
    this.initialText,
    });

  @override
  AddNoteScreenState createState() => AddNoteScreenState();
}

class AddNoteScreenState extends State<AddNoteScreen> {
  late TextEditingController _controller; //TextEditingController mit einem Wert initialisieren, der erst im initState() verfügbar ist
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    //
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  void _saveNote() async {
    final text = _controller.text;
    if(text.isNotEmpty){

      if (widget.existingNoteId != null){
        // Update der vorhandenen Notiz:
        await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.existingNoteId)
        .update({
            'text': text,
            'timestamp': FieldValue.serverTimestamp(),
          }
        );
      } else{
        // Sonst: neue Notiz
        // Notiz abn Firebase schicken und in Firebase speichern 
        await FirebaseFirestore.instance.collection('notes').add({
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user?.uid,
        });
      }

       if (!mounted) return; //schützt vor ungültigem Kontext

      Navigator.pop(context); // schließt das aktuelle Fenster -->kehrt zurück zur Liste
    }
  }

  @override
  Widget build(BuildContext context) {

    final isEditing = widget.existingNoteId != null;  // wenn Notiz exisitiert dann isEditing = true

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Note' : 'New Note')),  // Wenn isEditing = true dann TextAnezige AppBar Edit Note sonst new Note
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'What do yout want to note?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text(isEditing ? 'Save Changes' : 'Save'),
            )
          ],
        ),
      ),
    );
  }
}