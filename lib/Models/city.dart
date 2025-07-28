import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  final String id;
  final String nombre;
  final bool activa;

  City({required this.id, required this.nombre, required this.activa});

  factory City.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return City(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      activa: data['activa'] ?? false,
    );
  }
}

Future<List<City>> listarCiudadesActivas() async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('ciudades')
          .where('activa', isEqualTo: true)
          .get();

  return snapshot.docs.map((doc) => City.fromFirestore(doc)).toList();
}

Future<List<City>> obtenerTodasCiudades() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('ciudades').get();
  return snapshot.docs.map((doc) => City.fromFirestore(doc)).toList();
}
