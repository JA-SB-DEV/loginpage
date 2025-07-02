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
        return User.fromFirestore(userDoc, roleDoc, cityDoc);
      }
      throw Exception('Usuario no encontrado');
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }
}
