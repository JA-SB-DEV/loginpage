import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  final String id;
  final String nombre;
  final int nivel;
  // final String descripcion;
  // final List<String> permisos;
  // final bool activo;

  Role({
    required this.id,
    required this.nombre,
    required this.nivel,
    // required this.descripcion,
    //requiered this.permisos,
    // required this.activo,
  });

  factory Role.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Role(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      nivel: data['nivel'] ?? 0,
      // descripcion: data['descripcion'] ?? '',
      // permisos: List<String>.from(data['permisos'] ?? []),
      // activo: data['activo'] ?? true,
    );
  }
}
