import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginpage/Controllers/city_controller.dart';
import 'package:loginpage/Models/city.dart' as model;

class ManageCitiesScreen extends StatefulWidget {
  const ManageCitiesScreen({super.key});

  @override
  State<ManageCitiesScreen> createState() => _ManageCitiesScreenState();
}

class _ManageCitiesScreenState extends State<ManageCitiesScreen> {
  List<model.City> cities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarCiudades();
  }

  Future<void> _cargarCiudades() async {
    setState(() => isLoading = true);
    final cityController = CityController();
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final idCity = userProvider.user?.idCity ?? '';
    final lista = await cityController.obtenerCiudades();
    setState(() {
      cities = lista;
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Gestionar Ciudades',
          style: GoogleFonts.inter(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : cities.isEmpty
              ? Center(
                child: Text(
                  'No hay ciudades activas',
                  style: GoogleFonts.inter(
                    color: colorScheme.onBackground,
                    fontSize: 16,
                  ),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return Card(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        city.nombre,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        city.activa ? 'activa' : 'inactiva',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                      // trailing: IconButton(
                      //   icon: Icon(Icons.edit_outlined),
                      //   onPressed: () {
                      //     // Aquí puedes implementar la lógica para editar la ciudad
                      //   },
                      // ),
                    ),
                  );
                },
              ),
    );
  }
}
