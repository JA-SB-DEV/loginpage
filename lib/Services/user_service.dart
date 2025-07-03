import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginpage/Models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> crearUsuario(User user) async {
    try {
      final docRef = _firestore.collection('usuarios').doc();
      user.id = docRef.id;
      await docRef.set(user.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  Future<List<User>> listaUsuariosDeMiCiudadConRol(String idCity) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('usuarios')
              .where('ciudad', isEqualTo: idCity)
              .get();

      if (querySnapshot.docs.isEmpty) return [];

      // Obtener la ciudad solo una vez
      final cityDoc = await _firestore.collection('ciudades').doc(idCity).get();

      // Obtener los roles únicos de los usuarios
      final roleIds =
          querySnapshot.docs
              .map((doc) => doc.data()['id_role'] as String? ?? '')
              .toSet()
              .where((id) => id.isNotEmpty)
              .toList();

      Map<String, DocumentSnapshot> rolesMap = {};
      if (roleIds.isNotEmpty) {
        final rolesQuery =
            await _firestore
                .collection('roles')
                .where(FieldPath.documentId, whereIn: roleIds)
                .get();
        rolesMap = {for (var doc in rolesQuery.docs) doc.id: doc};
      }

      // Construir la lista de usuarios con datos de rol y ciudad
      return querySnapshot.docs.map((userDoc) {
        final roleId = userDoc.data()['id_role'] as String? ?? '';
        final roleDoc = rolesMap[roleId];
        return User.fromFirestore2(userDoc, roleDoc, cityDoc);
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  Future<User> obtenerUsuarioPorID(String userId) async {
    try {
      final userDoc = await _firestore.collection('usuarios').doc(userId).get();
      final roleDoc =
          await _firestore
              .collection('roles')
              .doc(userDoc.data()?['id_role'])
              .get();
      final cityDoc =
          await _firestore
              .collection('ciudades')
              .doc(userDoc.data()?['ciudad'])
              .get();
      if (userDoc.exists) {
        return User.fromFirestore2(userDoc, roleDoc, cityDoc);
      }
      throw Exception('Usuario no encontrado');
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }
}
