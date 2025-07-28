import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginpage/Models/city.dart';

class CityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<City>> obtenerCiudades() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('ciudades').get();
      return snapshot.docs.map((doc) => City.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error al obtener ciudades: $e');
      return [];
    }
  }

  Future<List<City>> obtenerCiudadesActivas() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore
              .collection('ciudades')
              .where('activa', isEqualTo: true)
              .get();
      return snapshot.docs.map((doc) => City.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error al obtener ciudades: $e');
      return [];
    }
  }

  Future<City?> obtenerCiudadPorId(String id) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('ciudades').doc(id).get();
      if (doc.exists) {
        return City.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener ciudad por ID: $e');
      return null;
    }
  }
}
