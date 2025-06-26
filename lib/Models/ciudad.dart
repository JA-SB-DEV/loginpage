import 'package:cloud_firestore/cloud_firestore.dart';

class Ciudad {
  final String id;
  final String nombre;
  final bool activa;

  Ciudad({required this.id, required this.nombre, required this.activa});

  factory Ciudad.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ciudad(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      activa: data['activa'] ?? false,
    );
  }
}

Future<List<Ciudad>> obtenerCiudadesActivas() async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('ciudades')
          .where('activa', isEqualTo: true)
          .get();

  return snapshot.docs.map((doc) => Ciudad.fromFirestore(doc)).toList();
}

Future<List<Ciudad>> obtenerTodasCiudades() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('ciudades').get();
  return snapshot.docs.map((doc) => Ciudad.fromFirestore(doc)).toList();
}
