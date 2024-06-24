import 'package:fp_mobile/note.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class NoteWidget extends StatelessWidget {
  final Note _note;
  final Function() _onTap;

  NoteWidget(this._note, this._onTap);

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowChildren = [];

    rowChildren.add(Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _note.text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            _note.updatedAt.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            _note.cityName.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ));

    if (_note.imageURL.isNotEmpty) {
      rowChildren.add(Expanded(
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: _note.imageURL,
          width: 80,
        ),
      ));
    }
    
    return InkWell(
      onTap: this._onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowChildren,
          ),
        ),
      ),
    );
  }

}
