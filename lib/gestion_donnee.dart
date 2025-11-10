import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './Modele/registre_note.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  final String notesTableName = 'notes';

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'notes_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $notesTableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            creationDate TEXT
          )
        ''');
      },
    );
  }

  //Opérations Note (CRUD)

  // Ajout d'une note
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(notesTableName, note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Récupération de toutes les notes
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    // Trie par date de création du plus récent au plus ancien
    final List<Map<String, dynamic>> maps = await db.query(notesTableName, orderBy: 'creationDate DESC'); 

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Modification d'une note (UPDATE)
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      notesTableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Suppression d'une note (DELETE)
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(notesTableName, where: 'id = ?', whereArgs: [id]);
  }
}