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

  // ============ READ - Obtener todos los videojuegos ============
  Future<List<Videojuego>> getAllVideojuegos() async {
    Database db = await database;
    // query devuelve una lista de Maps
    List<Map<String, dynamic>> maps = await db.query('videojuegos');
    
    // Convertir cada Map en un objeto Videojuego
    return List.generate(maps.length, (i) {
      return Videojuego.fromMap(maps[i]);
    });
  }

  // ============ UPDATE - Actualizar un videojuego ============
  Future<int> updateVideojuego(Videojuego videojuego) async {
    Database db = await database;
    // update devuelve el número de filas afectadas
    return await db.update(
      'videojuegos',
      videojuego.toMap(),
      where: 'id = ?', // Condición: buscar por ID
      whereArgs: [videojuego.id], // El ID del videojuego a actualizar
    );
  }

  // ============ DELETE - Eliminar un videojuego ============
  Future<int> deleteVideojuego(int id) async {
    Database db = await database;
    // delete devuelve el número de filas eliminadas
    return await db.delete(
      'videojuegos',
      where: 'id = ?', // Condición: buscar por ID
      whereArgs: [id], // El ID del videojuego a eliminar
    );
  }

  // Cerrar la base de datos
  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}
