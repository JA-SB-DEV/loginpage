import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  // Simulación de usuarios
  List<Map<String, dynamic>> users = [
    {
      'nombre': 'Juan Pérez',
      'correo': 'juan@ejemplo.com',
      'permisos': {'inventario': true, 'envios': false},
    },
    {
      'nombre': 'Ana López',
      'correo': 'ana@ejemplo.com',
      'permisos': {'inventario': true, 'envios': true},
    },
  ];

  void _showUserForm({Map<String, dynamic>? user, int? index}) {
    final nombreController = TextEditingController(text: user?['nombre'] ?? '');
    final correoController = TextEditingController(text: user?['correo'] ?? '');
    bool inventario = user?['permisos']?['inventario'] ?? false;
    bool envios = user?['permisos']?['envios'] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            user == null ? 'Crear usuario' : 'Editar usuario',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: correoController,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (user != null) ...[
                    SwitchListTile(
                      title: const Text('Permiso Inventario'),
                      value: inventario,
                      onChanged: (val) => setState(() => inventario = val),
                    ),
                    SwitchListTile(
                      title: const Text('Permiso Envíos'),
                      value: envios,
                      onChanged: (val) => setState(() => envios = val),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(user == null ? 'Crear' : 'Guardar'),
              onPressed: () {
                if (nombreController.text.trim().isEmpty ||
                    correoController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Completa todos los campos')),
                  );
                  return;
                }
                if (user == null) {
                  // Al crear, los permisos por defecto pueden ser false
                  final nuevoUsuario = {
                    'nombre': nombreController.text,
                    'correo': correoController.text,
                    'permisos': {'inventario': false, 'envios': false},
                  };
                  setState(() {
                    users.add(nuevoUsuario);
                  });
                } else if (index != null) {
                  // Al editar, guarda los permisos
                  final usuarioEditado = {
                    'nombre': nombreController.text,
                    'correo': correoController.text,
                    'permisos': {'inventario': inventario, 'envios': envios},
                  };
                  setState(() {
                    users[index] = usuarioEditado;
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Gestionar usuarios',
          style: GoogleFonts.inter(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            tooltip: 'Crear usuario',
            onPressed: () => _showUserForm(),
          ),
        ],
      ),
      body:
          users.isEmpty
              ? Center(
                child: Text(
                  'No hay usuarios registrados.',
                  style: GoogleFonts.inter(
                    color: colorScheme.onBackground,
                    fontSize: 16,
                  ),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        user['nombre'],
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['correo']),
                          const SizedBox(height: 4),
                          Text(
                            'Permisos: '
                            '${user['permisos']['inventario'] ? 'Inventario ' : ''}'
                            '${user['permisos']['envios'] ? 'Envíos' : ''}',
                            style: GoogleFonts.inter(fontSize: 13),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: 'Editar',
                            onPressed:
                                () => _showUserForm(user: user, index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Eliminar',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Eliminar usuario'),
                                      content: const Text(
                                        '¿Estás seguro de eliminar este usuario?',
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed:
                                              () => Navigator.pop(context),
                                        ),
                                        ElevatedButton(
                                          child: const Text('Eliminar'),
                                          onPressed: () {
                                            setState(() {
                                              users.removeAt(index);
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
