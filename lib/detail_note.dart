import 'package:flutter/material.dart';
import './Modele/registre_note.dart';
import 'gestion_donnee.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;
  final VoidCallback onSave;

  const NoteDetailScreen({super.key, this.note, required this.onSave});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _currentDate = widget.note!.creationDate;
    } else {
      _currentDate = DateTime.now();
    }
  }

  void _saveNote() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le titre ne peut pas être vide.')),
      );
      return;
    }

    if (widget.note == null) {
      final newNote = Note(
        title: _titleController.text,
        content: _contentController.text,
        creationDate: _currentDate,
      );
      await _dbService.insertNote(newNote);
    } else {
      final updatedNote = Note(
        id: widget.note!.id,
        title: _titleController.text,
        content: _contentController.text,
        creationDate: _currentDate,
        isCompleted: widget.note?.isCompleted ?? false,
      );

      if (widget.note == null) {
      // Mode Ajout (CREATE)
        await _dbService.insertNote(updatedNote);
      } else {
        // Mode Modification (UPDATE)
        await _dbService.updateNote(updatedNote);
      }
    }
    widget.onSave();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nouvelle Note' : 'Modifier Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Créé le: ${Note(title: '', content: '', creationDate: _currentDate).formattedDate}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre de la note',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _contentController,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Contenu de la note...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}