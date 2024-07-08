import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  final String noteText;
  final Function() editNote;
  final Function() deleteNote;

  const NoteTile(
      {super.key,
      required this.noteText,
      required this.deleteNote,
      required this.editNote});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.fromLTRB(8, 16, 4, 16),
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: ListTile(
        title: Text(
          noteText,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: editNote, icon: const Icon(Icons.settings)),
            IconButton(
                onPressed: deleteNote,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ],
        ),
      ),
    );
  }
}