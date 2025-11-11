import 'package:flutter/material.dart';
import './Modele/registre_note.dart';
import 'gestion_donnee.dart';
import 'detail_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final notes = await _dbService.getAllNotes();
    setState(() {
      _allNotes = notes;
      _filterNotes();
    });
  }

  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _allNotes.where((note) {
        return note.title.toLowerCase().contains(query) ||
               note.content.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _goToAddNote() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NoteDetailScreen(onSave: _loadNotes)),
    );
  }

  void _goToEditNote(Note note) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NoteDetailScreen(note: note, onSave: _loadNotes)),
    );
  }

  void _deleteNote(int id) async {
    await _dbService.deleteNote(id);
    _loadNotes();
  }

  void _toggleCompletion(Note note, bool? newValue) async {
  if (newValue == null) return;

  final updatedNote = Note(
    id: note.id,
    title: note.title,
    content: note.content,
    creationDate: note.creationDate,
    isCompleted: newValue,
  );

  await _dbService.updateNote(updatedNote);
  _loadNotes();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notes'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Rechercher une note...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                return CheckboxListTile(
                  value: note.isCompleted,
                  onChanged: (bool? newValue) => _toggleCompletion(note, newValue),
                  title: Text(note.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: note.isCompleted ? TextDecoration.lineThrough : null,
                    )),
                  subtitle: Text('Créé le: ${note.formattedDate}'),
                  secondary: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (note.isCompleted)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Chip(
                            labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
                            label: Text('Terminé', style: TextStyle(color: Colors.white, fontSize: 8)),
                            backgroundColor: Colors.green,
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _goToEditNote(note),
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteNote(note.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}