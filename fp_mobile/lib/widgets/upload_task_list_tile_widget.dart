import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key? key, required this.task, required this.onDismissed, required this.onDownload})
      : super(key: key);

  final UploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
  String result;
  switch (task.snapshot.state) {
    case TaskState.success:
      result = 'Complete';
      break;
    case TaskState.canceled:
      result = 'Canceled';
      break;
    case TaskState.running:
      result = 'Uploading';
      break;
    case TaskState.paused:
      result = 'Paused';
      break;
    default:
      result = 'Unknown';
      break;
  }
  return result;
}


  String _bytesTransferred(TaskSnapshot snapshot) {
  final percentage =
      (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
  return "${percentage.toInt()}%";
  }


  @override
Widget build(BuildContext context) {
  return StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
      Widget subtitle;
      if (asyncSnapshot.hasData) {
        final TaskSnapshot? event = asyncSnapshot.data;
        final TaskSnapshot snapshot = event!;
        subtitle = Text('${_bytesTransferred(snapshot)}');
      } else {
        subtitle = const Text('Starting...');
      }
      return ListTile(
        key: Key(task.hashCode.toString()),
        title: Text('$status'),
        subtitle: subtitle,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Offstage(
              offstage: task.snapshot.state != TaskState.running,
              child: IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () => task.pause(),
              ),
            ),
            Offstage(
              offstage: task.snapshot.state != TaskState.paused,
              child: IconButton(
                icon: const Icon(Icons.file_upload),
                onPressed: () => task.resume(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

}
