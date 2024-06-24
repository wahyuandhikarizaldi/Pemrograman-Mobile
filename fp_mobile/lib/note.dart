import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String uid;
  String text;
  String imageURL;
  DateTime createdAt;
  DateTime updatedAt;
  double? latitude;
  double? longitude;
  String? cityName;

  String get description => "$uid-$text-$createdAt";

  Note({
    required this.uid,
    required this.text,
    this.imageURL = '',
    this.latitude,
    this.longitude,
    this.cityName,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Note.clone(Note note)
      : this(
          uid: note.uid,
          text: note.text,
          imageURL: note.imageURL,
          createdAt: note.createdAt,
          updatedAt: note.updatedAt,
          latitude: note.latitude, 
          longitude: note.longitude,
          cityName: note.cityName,
        );

  Note.fromJSON(Map<String, dynamic> json)
      : uid = json['uid'],
        text = json['text'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(
            json['createdAt'].millisecondsSinceEpoch),
        updatedAt = DateTime.fromMillisecondsSinceEpoch(
            json['updatedAt'].millisecondsSinceEpoch),
        imageURL = json['imageURL'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        cityName = json['cityName'];

  Note.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.id,
        text = snapshot['text'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(
            snapshot['createdAt'].millisecondsSinceEpoch),
        updatedAt = DateTime.fromMillisecondsSinceEpoch(
            snapshot['updatedAt'].millisecondsSinceEpoch),
        imageURL = snapshot['imageURL'],
        latitude = snapshot['latitude'],
        longitude = snapshot['longitude'],
        cityName = snapshot['cityName'];
}
