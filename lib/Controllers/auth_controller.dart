import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para iniciar sesión con correo electrónico y contraseña
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // ⚠️ Captura de errores específicos
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No existe un usuario con ese correo.');
        case 'wrong-password':
          throw Exception('La contraseña es incorrecta.');
        case 'invalid-email':
          throw Exception('El correo no es válido.');
        case 'user-disabled':
          throw Exception('El usuario ha sido deshabilitado.');
        default:
          throw Exception('Error al iniciar sesión. Intenta de nuevo.');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  // Método para registrar un nuevo usuario
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Error al registrar usuario: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al registrar usuario: $e');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream para saber si hay sesión activa
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
