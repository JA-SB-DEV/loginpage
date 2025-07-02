import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginpage/Models/product.dart';

class ProductoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> crearProducto(Producto producto) async {
    try {
      final docRef = _firestore.collection('productos').doc();
      producto.id = docRef.id;
      await docRef.set(producto.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear producto: $e');
    }
  }

  // Actualiza el stock
  Future<void> actualizarStockProducto(
    String productoId,
    int nuevoStock,
  ) async {
    try {
      await _firestore.collection('productos').doc(productoId).update({
        'stock': nuevoStock,
      });
    } catch (e) {
      throw Exception('Error al actualizar stock: $e');
    }
  }

  // Buscar producto por código QR
  Future<Producto?> buscarProductoPorCodigo(String codigo) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('productos')
              .where('codigo', isEqualTo: codigo)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Producto.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Error al buscar producto: $e');
    }
  }

  Future<Producto> obtenerProducto(String productoId) async {
    try {
      final doc =
          await _firestore.collection('productos').doc(productoId).get();
      if (doc.exists) {
        return Producto.fromFirestore(doc);
      }
      throw Exception('Producto no encontrado');
    } catch (e) {
      throw Exception('Error al obtener producto: $e');
    }
  }
}
