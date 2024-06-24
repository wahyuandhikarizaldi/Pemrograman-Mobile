import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'note_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fp_mobile/widgets/note_list_widget.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noteModel = NoteModel();
    return ScopedModel(
      model: noteModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(155, 68, 152, 1.0),
        ),
        home: NoteListWidget(title: 'Notes'),
      ),
    );
  }
}
