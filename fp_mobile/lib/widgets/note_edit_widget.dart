// ignore_for_file: body_might_complete_normally_catch_error

import 'package:flutter/material.dart';
import 'package:fp_mobile/note_model.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:scoped_model/scoped_model.dart';
import 'package:fp_mobile/note.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'upload_task_list_tile_widget.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:io';

class NoteEditWidget extends StatefulWidget {
  final Note? _note;

  NoteEditWidget(this._note);

  @override
  _NoteEditWidgetState createState() => _NoteEditWidgetState();
}

class _NoteEditWidgetState extends State<NoteEditWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Location location = Location();
  String? _cityName;

  UploadTask? _task;
  File? _image;

  bool get isEditing => widget._note != null;
  NoteModel get _noteModel => ScopedModel.of<NoteModel>(context);

  void uploadFile(File file, Note note) {
    final String uuid = note.uid;

    final Reference ref = storage.ref().child('images').child("$uuid.jpg");
    final UploadTask task = ref.putFile(
      file,
      SettableMetadata(
        contentType: 'image/jpeg',
      ),
    );

    setState(() {
      _task = task;
    });

    task.whenComplete(() async {
      final downloadUrl = await ref.getDownloadURL();
      note.imageURL = downloadUrl;
      _noteModel.editNote(note, (_) {
        Navigator.pop(context);
      });

      setState(() {
        _task = null;
      });
    }).catchError((e) {
      setState(() {
        _task = null;
      });

      showInSnackBar('Upload Failed');
    });

    showInSnackBar('Uploading Image...');
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
    );
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 512,
      maxWidth: 512,
    );
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<String?> getCityName(double latitude, double longitude) async {
    try {
      List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks[0].locality;
      }
    } catch (e) {
      print('Error getting city name: $e');
    }
    return null;
  }

  Future<LocationData?> getLocation() async {
    try {
      return await location.getLocation();
    } catch (e) {
      print('Could not get location: $e');
      return null;
    }
  }

  Future<void> _getLocationAndCityName() async {
    try {
      final locationData = await location.getLocation();
      final cityName = await getCityName(locationData.latitude!, locationData.longitude!);
      setState(() {
        _cityName = cityName;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void addNote(String text) async {
    final locationData = await getLocation();
    final cityName = await getCityName(locationData!.latitude!, locationData.longitude!);
    final newNote = Note(
      uid: UniqueKey().toString(),
      text: text,
      imageURL: '',
      latitude: locationData.latitude,
      longitude: locationData.longitude,
      cityName: cityName,
    );

    _noteModel.addNote(newNote, (note) {
      if (_image != null) {
        uploadFile(_image!, note);
      } else {
        Navigator.pop(context);
      }
    });
    showInSnackBar('Adding Note...');
  }

  void updateNote(Note note, String text) async {
    widget._note!.text = text;
    final locationData = await getLocation();
    final cityName = await getCityName(locationData!.latitude!, locationData.longitude!);
    final updatedNote = Note(
      uid: widget._note!.uid,
      text: text,
      imageURL: widget._note!.imageURL,
      latitude: locationData.latitude,
      longitude: locationData.longitude,
      cityName: cityName,
      createdAt: widget._note!.createdAt,
      updatedAt: DateTime.now(),
    );

    _noteModel.editNote(updatedNote, (updatedNote) {
      if (_image != null) {
        uploadFile(_image!, updatedNote);
      } else {
        Navigator.pop(context);
      }
    });
    showInSnackBar('Updating Note');
  }


  void deleteNote(Note note) {
    final noteModel = ScopedModel.of<NoteModel>(context);
    noteModel.deleteNote(widget._note!, () => Navigator.pop(context));
    showInSnackBar('Deleting Note...');
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  void initState() {
    _textController.text = isEditing ? widget._note!.text : '';
    super.initState();
    if (widget._note == null) {
      _getLocationAndCityName();
    } else {
      _cityName = widget._note!.cityName;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _formChildren = [];
    if (_image != null) {
      _formChildren.add(Center(
        child: Image.file(_image!),
      ));
    } else if (isEditing && widget._note!.imageURL.isNotEmpty) {
      _formChildren.add(Center(
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: widget._note!.imageURL,
        ),
      ));
    }

    _formChildren.add(TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: _textController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    ));

   if (_cityName != null) {
      _formChildren.add(Text(
        '$_cityName',
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
    }

    _formChildren.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ScopedModelDescendant<NoteModel>(
        builder: (context, child, note) {
          return ElevatedButton(
            onPressed: note.isSubmittingNote || _task != null
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      final text = _textController.text;
                      if (isEditing) {
                        updateNote(widget._note!, text);
                      } else {
                        addNote(text);
                      }
                    }
                  },
            child: Text('Submit'),
          );
        },
      ),
    ));

    if (this._task != null && this._task!.snapshot.state != TaskState.success) {
      _formChildren.add(UploadTaskListTile(
        task: _task!,
        onDismissed: () => setState(() => _task = null),
        onDownload: () {},
      ));
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Add Note'),
        actions: isEditing
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteNote(widget._note!),
                ),
              ]
            : null,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _task != null || _noteModel.isSubmittingNote ? null : getImageFromGallery,
            tooltip: 'Pick Image from Gallery',
            child: const Icon(Icons.photo),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _task != null || _noteModel.isSubmittingNote ? null : getImageFromCamera,
            tooltip: 'Take a Photo',
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: _formChildren,
          ),
        ),
      ),
    );
  }
}
