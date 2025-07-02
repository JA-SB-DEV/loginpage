import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  Timestamp? createdAt;
  String? idCity; // ID del documento de ciudad
  String? cityName; // Nombre de la ciudad, opcional
  String? idSede; // ID del documento de sede
  String? idRole; // ID del documento de rol
  String? roleName; // Nombre del rol, opcional

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.createdAt,
    this.idCity,
    this.cityName,
    this.idSede,
    this.idRole,
    this.roleName,
  });

  factory User.fromFirestore(
    DocumentSnapshot userDoc,
    DocumentSnapshot roleDoc,
    DocumentSnapshot cityDoc,
  ) {
    final data = userDoc.data() as Map<String, dynamic>;
    final roleData = roleDoc.data() as Map<String, dynamic>;
    final cityData = cityDoc.data() as Map<String, dynamic>;
    return User(
      id: userDoc.id,
      name: data['nombre'] ?? '',
      email: data['email'] ?? '',
      phone: data['telefono'] ?? '',
      createdAt: data['fecha_registro'] as Timestamp?,
      idCity: data['ciudad'] ?? '',
      cityName: cityData['nombre'] ?? '',
      idSede: data['sede'] ?? '',
      idRole: data['id_role'] ?? '',
      roleName: roleData['nombre'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': name,
      'email': email,
      'telefono': phone,
      'fecha_registro': createdAt ?? FieldValue.serverTimestamp(),
      'ciudad': idCity,
      'sede': idSede,
      'id_role': idRole,
    };
  }

  Future<void> crearUsuarioDesdeAuth() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('No hay usuario autenticado');
    id = uid;

    final docRef = FirebaseFirestore.instance.collection('usuarios').doc(id);
    await docRef.set(toFirestore());
  }

  Future<void> cargarUsuarioDesdeFirestore(String userId) async {
    final docRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      id = docSnapshot.id;
      name = data['nombre'];
      email = data['email'];
      phone = data['telefono'];
      createdAt = data['fecha_registro'] as Timestamp?;
      idCity = data['ciudad'];
      idSede = data['sede'];
      idRole = data['id_role'];
    } else {
      throw Exception('Usuario no encontrado');
    }
  }
}
