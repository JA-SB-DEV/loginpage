import 'package:loginpage/Services/role_service.dart';
import 'package:loginpage/Models/role.dart';

class RoleController {
  final RoleService _roleService = RoleService();

  Future<List<Role>> obtenerRoles() async {
    try {
      return await _roleService.obtenerRoles();
    } catch (e) {
      throw Exception('Error al listar roles: $e');
    }
  }

  Future<List<Role>> obtenerRolesSinAdmin() async {
    try {
      return await _roleService.obtenerRolesSinAdmin();
    } catch (e) {
      throw Exception('Error al listar roles sin administrador: $e');
    }
  }

  Future<Role> obtenerRolPorId(String id) async {
    try {
      return await _roleService.obtenerRolPorId(id);
    } catch (e) {
      throw Exception('Error al obtener rol por ID: $e');
    }
  }
}
