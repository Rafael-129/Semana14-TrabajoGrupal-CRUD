import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import '../database/database_helper.dart';

class EditarVideojuegoScreen extends StatefulWidget {
  final Videojuego videojuego; // Recibimos el videojuego a editar

  const EditarVideojuegoScreen({super.key, required this.videojuego});

  @override
  State<EditarVideojuegoScreen> createState() => _EditarVideojuegoScreenState();
}

class _EditarVideojuegoScreenState extends State<EditarVideojuegoScreen> {
  // Controladores para los campos de texto
  late TextEditingController _tituloController;
  
  // Variables para los dropdowns
  String? _plataformaSeleccionada;
  String? _generoSeleccionado;
  bool _completado = false;
  
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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Prellenar los campos con los datos del videojuego
    _tituloController = TextEditingController(text: widget.videojuego.titulo);
    _plataformaSeleccionada = widget.videojuego.plataforma;
    _generoSeleccionado = widget.videojuego.genero;
    _completado = widget.videojuego.completado;
  }

  // Función para actualizar el videojuego
  Future<void> _actualizarVideojuego() async {
    if (_formKey.currentState!.validate() && 
        _plataformaSeleccionada != null && 
        _generoSeleccionado != null) {
      
      // Crear el objeto actualizado
      Videojuego juegoActualizado = Videojuego(
        id: widget.videojuego.id, // Mantener el mismo ID
        titulo: _tituloController.text,
        plataforma: _plataformaSeleccionada!,
        genero: _generoSeleccionado!,
        completado: _completado,
      );

      // Actualizar en la base de datos
      DatabaseHelper db = DatabaseHelper();
      int result = await db.updateVideojuego(juegoActualizado);

      if (mounted) {
        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Videojuego actualizado!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // true = se actualizó
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al actualizar'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
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
        title: const Text('Editar Videojuego'),
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
                Icons.edit,
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
              const SizedBox(height: 16),

              // Switch: Completado
              Card(
                child: SwitchListTile(
                  title: const Text('¿Ya lo completaste?'),
                  subtitle: Text(_completado ? 'Sí, lo terminé' : 'Aún no'),
                  value: _completado,
                  onChanged: (value) {
                    setState(() {
                      _completado = value;
                    });
                  },
                  activeColor: Colors.green,
                  secondary: Icon(
                    _completado ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: _completado ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón para actualizar
              ElevatedButton.icon(
                onPressed: _actualizarVideojuego,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Cambios'),
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
