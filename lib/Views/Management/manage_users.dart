import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginpage/Controllers/user_controller.dart';
import 'package:loginpage/Controllers/user_provider.dart';
import 'package:loginpage/Models/user.dart' as model;
import 'package:provider/provider.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<model.User> usuarios = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    setState(() => cargando = true);
    final userController = UserController();
    // Obtener el idCity del usuario actual desde el UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final idCity = userProvider.user?.idCity ?? '';
    final lista = await userController.obtenerUsuariosDeCiudadConRol(idCity);
    setState(() {
      usuarios = lista;
      cargando = false;
    });
  }

  void _showUserForm({model.User? user, int? index}) {
    final nombreController = TextEditingController(text: user?.name ?? '');
    final correoController = TextEditingController(text: user?.email ?? '');
    // Suponiendo que tienes campos de permisos en tu modelo
    // bool inventario = user?.permisos?.inventario ?? false;
    // bool envios = user?.permisos?.envios ?? false;

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
                  // if (user != null) ...[
                  //   SwitchListTile(
                  //     title: const Text('Permiso Inventario'),
                  //     value: inventario,
                  //     onChanged: (val) => setState(() => inventario = val),
                  //   ),
                  //   SwitchListTile(
                  //     title: const Text('Permiso Envíos'),
                  //     value: envios,
                  //     onChanged: (val) => setState(() => envios = val),
                  //   ),
                  // ],
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
                // Aquí deberías implementar la lógica para crear o editar usuarios usando tu UserController
                // Por simplicidad, solo actualizamos la lista local
                if (user == null) {
                  // Crear usuario (esto debería hacerse con UserController y recargar la lista)
                  final nuevoUsuario = model.User(
                    name: nombreController.text,
                    email: correoController.text,
                    // Completa los demás campos requeridos por tu modelo
                  );
                  setState(() {
                    usuarios.add(nuevoUsuario);
                  });
                } else if (index != null) {
                  // Editar usuario (esto debería hacerse con UserController y recargar la lista)
                  final usuarioEditado = model.User(
                    name: nombreController.text,
                    email: correoController.text,
                    // Completa los demás campos requeridos por tu modelo
                  );
                  setState(() {
                    usuarios[index] = usuarioEditado;
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
          cargando
              ? const Center(child: CircularProgressIndicator())
              : usuarios.isEmpty
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
                itemCount: usuarios.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = usuarios[index];
                  return Card(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        user.name ?? '-',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email ?? '-'),
                          const SizedBox(height: 4),
                          Text(
                            'Ciudad: ${user.cityName ?? "-"}',
                            style: GoogleFonts.inter(fontSize: 13),
                          ),
                          Text(
                            'Rol: ${user.roleName ?? "-"}',
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
                                              usuarios.removeAt(index);
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
