import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  Timestamp? createdAt;
  String? city; // ID del documento de ciudad
  String? sede; // ID del documento de sede
  String? idrole; // ID del documento de rol

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.createdAt,
    this.city,
    this.sede,
    this.idrole,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['nombre'] ?? '',
      email: data['email'] ?? '',
      phone: data['telefono'] ?? '',
      createdAt: data['fecha_registro'] as Timestamp?,
      city: data['ciudad'] ?? '',
      sede: data['sede'] ?? '',
      idrole: data['id_role'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': name,
      'email': email,
      'telefono': phone,
      'fecha_registro': createdAt ?? FieldValue.serverTimestamp(),
      'ciudad': city,
      'sede': sede,
      'id_role': idrole,
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
      city = data['ciudad'];
      sede = data['sede'];
      idrole = data['id_role'];
    } else {
      throw Exception('Usuario no encontrado');
    }
  }
}
