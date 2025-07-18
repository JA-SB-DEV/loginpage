import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginpage/Controllers/sede_controller.dart';
import 'package:loginpage/Controllers/user_provider.dart';
import 'package:loginpage/Models/sede.dart' as model;
import 'package:provider/provider.dart';

class ManageBranchesScreen extends StatefulWidget {
  const ManageBranchesScreen({super.key});

  @override
  State<ManageBranchesScreen> createState() => _ManageBranchesScreenState();
}

class _ManageBranchesScreenState extends State<ManageBranchesScreen> {
  final SedeController _sedeController = SedeController();
  List<model.Sede> branches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    setState(() {
      isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    final idCity = user?.idCity ?? '';
    branches = await _sedeController.obtenerSedes(idCity);
    if (user != null) {
      branches = branches.where((branch) => branch.activa).toList();
    }
    setState(() {
      isLoading = false;
    });
  }

  void _showBranchForm({model.Sede? branch, int? index}) {
    final controller = TextEditingController(text: branch?.name ?? '');
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
            branch == null ? 'Crear sede' : 'Editar sede',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nombre de la sede',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(branch == null ? 'Crear' : 'Guardar'),
              onPressed: () async {
                if (controller.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El nombre no puede estar vacío'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final cityId =
                    Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).user?.idCity ??
                    '';
                // print('City ID: $cityId');
                try {
                  await _sedeController.crearSede(
                    cityId: cityId,
                    nombre: controller.text.trim(),
                  );
                  await _loadBranches();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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
          'Gestionar sedes',
          style: GoogleFonts.inter(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_outlined),
            tooltip: 'Crear sede',
            onPressed: () => _showBranchForm(),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : branches.isEmpty
              ? Center(
                child: Text(
                  'No hay sedes registradas.',
                  style: GoogleFonts.inter(
                    color: colorScheme.onBackground,
                    fontSize: 16,
                  ),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: branches.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final branch = branches[index];
                  return Card(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        branch.name,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: 'Editar',
                            onPressed:
                                () => _showBranchForm(
                                  branch: branch,
                                  index: index,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Eliminar',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Eliminar sede'),
                                      content: const Text(
                                        '¿Estás seguro de eliminar esta sede?',
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
                                              branches.removeAt(index);
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
