import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginpage/Models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> crearUsuario(User user, User usuarioActual) async {
    try {
      final roleDoc =
          await _firestore.collection('roles').doc(usuarioActual.idRole).get();
      if (!roleDoc.exists) {
        throw Exception('Rol no encontrado');
      }
      final String? roleName = roleDoc.data()?['nombre'];
      if (roleName != 'Superadministrador') {
        throw Exception('Solo un administrador puede crear usuarios');
      }

      final cityDoc =
          await _firestore
              .collection('ciudades')
              .doc(usuarioActual.idCity)
              .get();
      if (!cityDoc.exists) {
        throw Exception('Ciudad no encontrada');
      }
      if (usuarioActual.idCity != user.idCity) {
        throw Exception('No puedes crear usuarios en otra ciudad');
      }

      final sedeDoc =
          await cityDoc.reference.collection('sedes').doc(user.idSede).get();
      if (!sedeDoc.exists) {
        throw Exception('Esta sede no existe en la ciudad seleccionada');
      }
      final docRef = _firestore.collection('usuarios').doc();
      user.id = docRef.id;
      await docRef.set(user.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear usuario: ${e.toString()}');
    }
  }

  Future<List<User>> listaUsuariosDeMiCiudadConRol(String idCity) async {
    try {
      final usuariosSnapshot =
          await _firestore
              .collection('usuarios')
              .where('ciudad', isEqualTo: idCity)
              .get();

      if (usuariosSnapshot.docs.isEmpty) return [];

      final cityDoc = await _firestore.collection('ciudades').doc(idCity).get();

      // Obtener todos los roles necesarios en un solo query
      final roleIds =
          usuariosSnapshot.docs
              .map((doc) => doc['id_role'] as String)
              .toSet()
              .toList();

      final rolesSnapshot =
          await _firestore
              .collection('roles')
              .where(FieldPath.documentId, whereIn: roleIds)
              .get();

      final rolesMap = {for (var doc in rolesSnapshot.docs) doc.id: doc};

      // Construir la lista de usuarios
      return usuariosSnapshot.docs.map((userDoc) {
        final roleDoc = rolesMap[userDoc['id_role']];
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
