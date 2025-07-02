import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginpage/Models/product.dart';
import 'package:loginpage/Services/product_service.dart';

class ProductoController {
  final ProductoService _productoService = ProductoService();

  Future<String> crearProducto({
    required String nombre,
    required Timestamp fechaInicio,
    required Timestamp fechaVencimiento,
    required String lote,
    required double precio,
    required String descripcion,
    required String codigo,
    required int stock,
    required bool esComprado,
  }) async {
    final nuevoProducto = Producto(
      nombre: nombre,
      fechaInicio: fechaInicio,
      fechaVencimiento: fechaVencimiento,
      lote: lote,
      precio: precio,
      descripcion: descripcion,
      codigo: codigo,
      stock: stock,
      esComprado: esComprado,
    );

    return await _productoService.crearProducto(nuevoProducto);
  }

  // Actualiza el stock
  Future<void> actualizarStockPorQR(String codigoQR, int nuevoStock) async {
    try {
      final producto = await _productoService.buscarProductoPorCodigo(codigoQR);

      if (producto != null) {
        await _productoService.actualizarStockProducto(
          producto.id!,
          nuevoStock,
        );
      } else {
        throw Exception(
          'Producto no encontrado con el código QR proporcionado',
        );
      }
    } catch (e) {
      throw Exception('Error en actualización por QR: $e');
    }
  }

  Future<Producto> obtenerProductoPorQR(String codigoQR) async {
    final producto = await _productoService.buscarProductoPorCodigo(codigoQR);
    if (producto == null) {
      throw Exception('Producto no encontrado');
    }
    return producto;
  }
}
