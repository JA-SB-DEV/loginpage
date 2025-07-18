import 'package:loginpage/Services/sede_service.dart';
import 'package:loginpage/Models/sede.dart';

class SedeController {
  final SedeService _sedeService = SedeService();

  Future<String> crearSede({
    String? cityId,
    required String nombre,
    bool activa = true,
    bool esPrincipal = false,
  }) async {
    final nuevaSede = Sede(
      cityId: cityId!,
      name: nombre,
      activa: activa,
      esPrincipal: esPrincipal,
    );

    return await _sedeService.crearSede(nuevaSede);
  }

  Future<List<Sede>> obtenerSedes(String idCity) async {
    return await _sedeService.listarSedesdeMiCiudad(idCity);
  }

  Future<void> actualizarSede(Sede sede) async {
    await _sedeService.actualizarSede(sede);
  }

  Future<void> eliminarSede(Sede sede) async {
    await _sedeService.eliminarSede(sede);
  }
}
