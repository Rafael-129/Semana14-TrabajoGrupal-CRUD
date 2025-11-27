class Videojuego {
  int? id; // El ? significa que puede ser null (cuando aún no se guarda en BD)
  String titulo;
  String plataforma; // Ej: "PlayStation", "Xbox", "PC", "Nintendo Switch"
  String genero; // Ej: "Acción", "RPG", "Deportes"
  bool completado; // true = ya lo terminaste, false = aún no

  // Constructor - sirve para crear un nuevo videojuego
  Videojuego({
    this.id,
    required this.titulo,
    required this.plataforma,
    required this.genero,
    this.completado = false, // Por defecto no está completado
  });

  // Convertir el videojuego a un Map (diccionario) para guardarlo en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'plataforma': plataforma,
      'genero': genero,
      'completado': completado ? 1 : 0, // SQLite guarda bool como 0 o 1
    };
  }

  // Crear un videojuego desde un Map (cuando lo sacamos de la BD)
  factory Videojuego.fromMap(Map<String, dynamic> map) {
    return Videojuego(
      id: map['id'],
      titulo: map['titulo'],
      plataforma: map['plataforma'],
      genero: map['genero'],
      completado: map['completado'] == 1, // 1 = true, 0 = false
    );
  }

  // Para imprimir el videojuego en consola (útil para debugging)
  @override
  String toString() {
    return 'Videojuego{id: $id, titulo: $titulo, plataforma: $plataforma, genero: $genero, completado: $completado}';
  }
}
