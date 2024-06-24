import 'package:fp_mobile/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

abstract class INoteService {
  static const int PER_PAGE = 20;

  Future<List<Note>> getNotes({dynamic nextCursor});
  Future<Note?> getNote(String uid);

  Future<Note> addNote(Note note);
  Future<Note> updateNote(Note note);
  Future<bool> deleteNote(Note note);
}

class FirestoreNoteService implements INoteService {
  static final _notesCollection = FirebaseFirestore.instance.collection("notes");

  @override
  Future<Note> addNote(Note note) async {
    final Map<String, dynamic> data = {
      'text': note.text,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'latitude': note.latitude,
      'longitude': note.longitude,
      'cityName': note.cityName,
    };

    data['imageURL'] = note.imageURL;

    final ref = await _notesCollection.add(data);

    final addedSnapshot = await ref.get();
    final addedNote = Note.fromSnapshot(addedSnapshot);
    return addedNote;
  }

  @override
  Future<bool> deleteNote(Note note) async {
    await _notesCollection.doc(note.uid).delete();
    return true;
  }

  @override
  Future<Note?> getNote(String uid) async {
    final snapshot = await _notesCollection.where("uid", isEqualTo: uid).get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return Note.fromSnapshot(doc);
    } else {
      return null;
    }
  }

  @override
  Future<List<Note>> getNotes({dynamic nextCursor}) async {
    var query = _notesCollection.orderBy('updatedAt', descending: true);
    if (nextCursor != null) {
      query = query.startAfter([nextCursor]);
    }

    query = query.limit(INoteService.PER_PAGE);

    final snapshot = await query.get();
    final notes = snapshot.docs.map((doc) => Note.fromSnapshot(doc)).toList();
    return notes;
  }

  @override
  Future<Note> updateNote(Note note) async {
    final ref = _notesCollection.doc(note.uid);

    final Map<String, dynamic> data = {
      'text': note.text,
      'updatedAt': FieldValue.serverTimestamp(),
      'latitude': note.latitude,
      'longitude': note.longitude,
      'cityName': note.cityName,
    };

    data['imageURL'] = note.imageURL;

    await ref.update(data);

    final updatedSnapshot = await ref.get();
    final updatedNote = Note.fromSnapshot(updatedSnapshot);
    return updatedNote;
  }
}
