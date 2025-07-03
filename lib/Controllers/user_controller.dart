import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginpage/Models/user.dart';
import 'package:loginpage/Services/user_service.dart';

class UserController {
  final UserService _userService = UserService();

  Future<String> crearUsuario({
    required String nombre,
    required String email,
    required String idCiudad,
    required String createdAt,
    required String telefono,
    required String idSede,
    required String idRole,
  }) async {
    final nuevoUsuario = User(
      name: nombre,
      email: email,
      idCity: idCiudad,
      createdAt: Timestamp.fromDate(DateTime.parse(createdAt)),
      phone: telefono,
      idSede: idSede,
      idRole: idRole,
    );

    return await _userService.crearUsuario(nuevoUsuario);
  }

  Future<List<User>> obtenerUsuariosDeCiudadConRol(String idCity) async {
    return await _userService.listaUsuariosDeMiCiudadConRol(idCity);
  }

  Future<User?> obtenerUsuarioPorID(String email) async {
    return await _userService.obtenerUsuarioPorID(email);
  }
}
