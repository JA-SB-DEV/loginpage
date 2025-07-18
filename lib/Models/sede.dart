import 'package:cloud_firestore/cloud_firestore.dart';

class Sede {
  String? id;
  String? cityId;
  String name;
  bool activa;
  bool esPrincipal;

  Sede({
    this.id,
    this.cityId,
    required this.name,
    this.activa = true,
    this.esPrincipal = false,
  });

  factory Sede.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Sede(
      id: doc.id,
      cityId: data['idCiudad'] ?? '',
      name: data['nombre'] ?? '',
      activa: data['activa'] ?? true,
      esPrincipal: data['esPrincipal'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    if (cityId == null || cityId!.isEmpty) {
      throw Exception('La sede debe pertenecer a una ciudad');
    }
    return {
      'idCiudad': cityId,
      'nombre': name,
      'activa': activa,
      'esPrincipal': esPrincipal,
    };
  }

  Future<void> crearSede() async {
    if (id!.isNotEmpty) throw Exception('La sede ya tiene un ID');
    final docRef = FirebaseFirestore.instance.collection('sedes').doc();
    id = docRef.id;
    await docRef.set(toFirestore());
  }

  Future<void> actualizarSede() async {
    if (id!.isEmpty) throw Exception('La sede no tiene un ID');
    await FirebaseFirestore.instance
        .collection('sedes')
        .doc(id)
        .update(toFirestore());
  }

  Future<void> eliminarSede() async {
    if (id!.isEmpty) throw Exception('La sede no tiene un ID');
    await FirebaseFirestore.instance.collection('sedes').doc(id).delete();
  }

  static Future<List<Sede>> obtenerSedes() async {
    final snapshot = await FirebaseFirestore.instance.collection('sedes').get();
    return snapshot.docs.map((doc) => Sede.fromFirestore(doc)).toList();
  }
}
