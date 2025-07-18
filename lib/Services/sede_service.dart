import 'package:loginpage/Models/sede.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SedeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> crearSede(Sede sede) async {
    try {
      if (sede.cityId != null && (sede.id ?? '').isNotEmpty) {
        throw Exception('La sede ya tiene un ID');
      }
      if (sede.cityId == null || sede.cityId!.isEmpty) {
        throw Exception('La sede debe pertenecer a una ciudad');
      }

      final docRef =
          _firestore
              .collection('ciudades')
              .doc(sede.cityId)
              .collection('sedes')
              .doc();
      sede.id = docRef.id;
      await docRef.set(sede.toFirestore());
      // print('Sede creada con ID: ${sede.id}');
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear sede: $e');
    }
  }

  Future<List<Sede>> listarSedesdeMiCiudad(String idCity) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('ciudades')
              .doc(idCity)
              .collection('sedes')
              .where('activa', isEqualTo: true)
              .get();

      if (querySnapshot.docs.isEmpty) return [];

      return querySnapshot.docs.map((doc) => Sede.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al obtener sedes: $e');
    }
  }

  Future<void> actualizarSede(Sede sede) async {
    try {
      await sede.actualizarSede();
    } catch (e) {
      throw Exception('Error al actualizar sede: $e');
    }
  }

  Future<void> eliminarSede(Sede sede) async {
    try {
      await sede.eliminarSede();
    } catch (e) {
      throw Exception('Error al eliminar sede: $e');
    }
  }
}
