import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginpage/Models/role.dart';

class RoleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Role>> obtenerRoles() async {
    try {
      final querySnapshot = await _firestore.collection('roles').get();
      return querySnapshot.docs.map((doc) => Role.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al listar roles: $e');
    }
  }

  Future<List<Role>> obtenerRolesSinAdmin() async {
    try {
      final querySnapshot =
          await _firestore
              .collection('roles')
              .where('nombre', isNotEqualTo: 'Superadministrador')
              .get();
      return querySnapshot.docs.map((doc) => Role.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al listar roles sin administrador: $e');
    }
  }

  Future<Role> obtenerRolPorId(String id) async {
    try {
      final doc = await _firestore.collection('roles').doc(id).get();
      if (!doc.exists) {
        throw Exception('Rol no encontrado');
      }
      return Role.fromFirestore(doc);
    } catch (e) {
      throw Exception('Error al obtener rol: $e');
    }
  }
}
