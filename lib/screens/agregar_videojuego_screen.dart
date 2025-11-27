import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import '../database/database_helper.dart';

class AgregarVideojuegoScreen extends StatefulWidget {
  const AgregarVideojuegoScreen({super.key});

  @override
  State<AgregarVideojuegoScreen> createState() => _AgregarVideojuegoScreenState();
}

class _AgregarVideojuegoScreenState extends State<AgregarVideojuegoScreen> {
  // Controladores para los campos de texto
  final TextEditingController _tituloController = TextEditingController();
  
  // Variables para los dropdowns
  String? _plataformaSeleccionada;
  String? _generoSeleccionado;
  
  // Listas de opciones
  final List<String> _plataformas = [
    'PlayStation 5',
    'PlayStation 4',
    'Xbox Series X/S',
    'Xbox One',
    'Nintendo Switch',
    'PC',
    'Mobile',
  ];
  
  final List<String> _generos = [
    'Acción',
    'Aventura',
    'RPG',
    'Deportes',
    'Carreras',
    'Estrategia',
    'Shooter',
    'Plataformas',
    'Puzzle',
  ];

  // Llave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Función para guardar el videojuego
  Future<void> _guardarVideojuego() async {
    // Validar que todos los campos estén llenos
    if (_formKey.currentState!.validate() && 
        _plataformaSeleccionada != null && 
        _generoSeleccionado != null) {
      
      // Crear el objeto Videojuego
      Videojuego nuevoJuego = Videojuego(
        titulo: _tituloController.text,
        plataforma: _plataformaSeleccionada!,
        genero: _generoSeleccionado!,
      );

      // Guardar en la base de datos
      DatabaseHelper db = DatabaseHelper();
      int id = await db.insertVideojuego(nuevoJuego);

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Videojuego agregado! ID: $id'),
            backgroundColor: Colors.green,
          ),
        );

        // Volver a la pantalla anterior
        Navigator.pop(context, true); // true = se agregó un juego
      }
    } else {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Videojuego'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icono decorativo
              const Icon(
                Icons.videogame_asset,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 24),

              // Campo: Título del juego
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título del juego',
                  hintText: 'Ej: The Legend of Zelda',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dropdown: Plataforma
              DropdownButtonFormField<String>(
                value: _plataformaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Plataforma',
                  prefixIcon: Icon(Icons.devices),
                  border: OutlineInputBorder(),
                ),
                items: _plataformas.map((plataforma) {
                  return DropdownMenuItem(
                    value: plataforma,
                    child: Text(plataforma),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _plataformaSeleccionada = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona una plataforma';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dropdown: Género
              DropdownButtonFormField<String>(
                value: _generoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Género',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: _generos.map((genero) {
                  return DropdownMenuItem(
                    value: genero,
                    child: Text(genero),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _generoSeleccionado = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona un género';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botón para guardar
              ElevatedButton.icon(
                onPressed: _guardarVideojuego,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Videojuego'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
