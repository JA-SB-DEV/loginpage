import 'package:loginpage/Services/city_service.dart';
import 'package:loginpage/Models/city.dart';

class CityController {
  final CityService _cityService = CityService();

  Future<List<City>> obtenerCiudades() async {
    try {
      return await _cityService.obtenerCiudades();
    } catch (e) {
      throw Exception('Error al obtener ciudades: $e');
    }
  }

  Future<List<City>> obtenerCiudadesActivas() async {
    try {
      return await _cityService.obtenerCiudadesActivas();
    } catch (e) {
      throw Exception('Error al obtener ciudades activas: $e');
    }
  }

  Future<City?> obtenerCiudadPorId(String id) async {
    return await _cityService.obtenerCiudadPorId(id);
  }
}
