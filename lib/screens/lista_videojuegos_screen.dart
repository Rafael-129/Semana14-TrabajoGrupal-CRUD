import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import '../database/database_helper.dart';
import 'agregar_videojuego_screen.dart';
import 'editar_videojuego_screen.dart';

class ListaVideojuegosScreen extends StatefulWidget {
  const ListaVideojuegosScreen({super.key});

  @override
  State<ListaVideojuegosScreen> createState() => _ListaVideojuegosScreenState();
}

class _ListaVideojuegosScreenState extends State<ListaVideojuegosScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Videojuego> _videojuegos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarVideojuegos();
  }

  // Función para cargar los videojuegos desde la BD
  Future<void> _cargarVideojuegos() async {
    setState(() {
      _isLoading = true;
    });

    List<Videojuego> juegos = await _dbHelper.getAllVideojuegos();

    setState(() {
      _videojuegos = juegos;
      _isLoading = false;
    });
  }

  // Función para obtener el icono según la plataforma
  IconData _getPlatformIcon(String plataforma) {
    if (plataforma.contains('PlayStation')) return Icons.sports_esports;
    if (plataforma.contains('Xbox')) return Icons.videogame_asset;
    if (plataforma.contains('Nintendo')) return Icons.gamepad;
    if (plataforma.contains('PC')) return Icons.computer;
    if (plataforma.contains('Mobile')) return Icons.phone_android;
    return Icons.games;
  }

  // Función para obtener el color según el género
  Color _getGenreColor(String genero) {
    switch (genero) {
      case 'Acción':
        return Colors.red;
      case 'Aventura':
        return Colors.orange;
      case 'RPG':
        return Colors.purple;
      case 'Deportes':
        return Colors.green;
      case 'Carreras':
        return Colors.blue;
      case 'Estrategia':
        return Colors.brown;
      case 'Shooter':
        return Colors.deepOrange;
      case 'Plataformas':
        return Colors.cyan;
      case 'Puzzle':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Colección de Juegos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            )
          : _videojuegos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videogame_asset_off,
                        size: 100,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No hay videojuegos aún',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Presiona el botón + para agregar uno',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarVideojuegos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _videojuegos.length,
                    itemBuilder: (context, index) {
                      Videojuego juego = _videojuegos[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          // Icono de plataforma
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            child: Icon(
                              _getPlatformIcon(juego.plataforma),
                              color: Colors.deepPurple,
                            ),
                          ),
                          // Título del juego
                          title: Text(
                            juego.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          // Plataforma
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.devices,
                                    size: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    juego.plataforma,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Chip del género
                              Chip(
                                label: Text(
                                  juego.genero,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: _getGenreColor(juego.genero),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          // Icono de completado
                          trailing: Icon(
                            juego.completado
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: juego.completado
                                ? Colors.green
                                : Colors.grey.shade400,
                            size: 28,
                          ),
                          // Al hacer tap, abrir pantalla de edición
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditarVideojuegoScreen(
                                  videojuego: juego,
                                ),
                              ),
                            );
                            // Recargar la lista cuando volvemos
                            _cargarVideojuegos();
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navegar a agregar videojuego y recargar al volver
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AgregarVideojuegoScreen(),
            ),
          );
          // Recargar la lista cuando volvemos
          _cargarVideojuegos();
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
