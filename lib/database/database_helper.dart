import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/videojuego.dart';

class DatabaseHelper {
  // Singleton - solo una instancia de DatabaseHelper en toda la app
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Getter para obtener la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDatabase() async {
    // Obtener la ruta donde se guardará la BD
    String path = join(await getDatabasesPath(), 'videojuegos.db');
    
    // Crear/abrir la base de datos
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Crear la tabla cuando se crea la BD por primera vez
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE videojuegos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        plataforma TEXT NOT NULL,
        genero TEXT NOT NULL,
        completado INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // ============ CREATE - Agregar un videojuego ============
  Future<int> insertVideojuego(Videojuego videojuego) async {
    Database db = await database;
    // insert devuelve el ID del nuevo registro
    return await db.insert('videojuegos', videojuego.toMap());
  }

  // Cerrar la base de datos
  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}
