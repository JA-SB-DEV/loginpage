import 'package:cloud_firestore/cloud_firestore.dart';

class Rol {
  final String id;
  final String nombre;
  final int nivel;
  // final String descripcion;
  // final List<String> permisos;
  // final bool activo;

  Rol({
    required this.id,
    required this.nombre,
    required this.nivel,
    // required this.descripcion,
    //requiered this.permisos,
    // required this.activo,
  });

  factory Rol.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Rol(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      nivel: data['nivel'] ?? 0,
      // descripcion: data['descripcion'] ?? '',
      // permisos: List<String>.from(data['permisos'] ?? []),
      // activo: data['activo'] ?? true,
    );
  }
}
