import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginpage/Controllers/user_controller.dart';
import 'package:loginpage/Controllers/user_provider.dart';
import 'package:loginpage/Models/city.dart';
import 'package:loginpage/Models/role.dart';
import 'package:loginpage/Models/sede.dart';
import 'package:loginpage/Models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:loginpage/Controllers/city_controller.dart';
import 'package:loginpage/Controllers/role_controller.dart';
import 'package:loginpage/Controllers/sede_controller.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<model.User> usuarios = [];
  bool cargando = true;

  List<City> ciudades = [];
  List<Role> roles = [];
  List<Sede> sedes = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
    _cargarDatosFormulario();
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

  Future<void> _cargarDatosFormulario() async {
    setState(() => cargando = true);
    final cityController = CityController();
    final roleController = RoleController();
    final sedeController = SedeController();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final idCity = userProvider.user?.idCity ?? '';

    ciudades = await cityController.obtenerCiudades();
    roles = await roleController.obtenerRolesSinAdmin();
    sedes = await sedeController.obtenerSedes(idCity);
    setState(() {
      cargando = false;
    });
  }

  void _showUserForm({model.User? user, int? index}) async {
    await _cargarDatosFormulario();

    final nombreController = TextEditingController(text: user?.name ?? '');
    final correoController = TextEditingController(text: user?.email ?? '');
    String? selectedCity =
        user?.idCity ?? (ciudades.isNotEmpty ? ciudades.first.id : null);
    String? selectedRole =
        user?.idRole ?? (roles.isNotEmpty ? roles.first.id : null);
    String? selectedSede =
        user?.idSede ?? (sedes.isNotEmpty ? sedes.first.id : null);

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: correoController,
                  decoration: const InputDecoration(labelText: 'Correo'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCity,
                  items:
                      ciudades
                          .map(
                            (city) => DropdownMenuItem(
                              value: city.id,
                              child: Text(city.nombre),
                            ),
                          )
                          .toList(),
                  onChanged: (val) => selectedCity = val,
                  decoration: const InputDecoration(labelText: 'Ciudad'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items:
                      roles
                          .map(
                            (role) => DropdownMenuItem(
                              value: role.id,
                              child: Text(role.nombre),
                            ),
                          )
                          .toList(),
                  onChanged: (val) => selectedRole = val,
                  decoration: const InputDecoration(labelText: 'Rol'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedSede,
                  items:
                      sedes
                          .map(
                            (sede) => DropdownMenuItem(
                              value: sede.id,
                              child: Text(sede.name),
                            ),
                          )
                          .toList(),
                  onChanged: (val) => selectedSede = val,
                  decoration: const InputDecoration(labelText: 'Sede'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(user == null ? 'Crear' : 'Guardar'),
              onPressed: () async {
                if (nombreController.text.trim().isEmpty ||
                    correoController.text.trim().isEmpty ||
                    selectedCity == null ||
                    selectedRole == null ||
                    selectedSede == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Completa todos los campos')),
                  );
                  return;
                }
                final userController = UserController();
                final userProvider = Provider.of<UserProvider>(
                  context,
                  listen: false,
                );
                final usuarioActual = userProvider.user!;
                if (user == null) {
                  await userController.crearUsuario(
                    nombre: nombreController.text.trim(),
                    email: correoController.text.trim(),
                    idCiudad: selectedCity,
                    idRole: selectedRole,
                    idSede: selectedSede,
                    telefono: '', // agrega campo si lo necesitas
                    createdAt: DateTime.now().toIso8601String(),
                    usuarioActual: usuarioActual,
                  );
                }
                await _cargarUsuarios();
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
