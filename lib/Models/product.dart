import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  String? id;
  String nombre;
  Timestamp fechaInicio;
  Timestamp fechaVencimiento;
  String lote;
  double precio;
  String descripcion;
  String codigo;
  int stock;
  bool esComprado;

  Producto({
    this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaVencimiento,
    required this.lote,
    required this.precio,
    required this.descripcion,
    required this.codigo,
    required this.stock,
    required this.esComprado,
  });

  factory Producto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Producto(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      fechaInicio: data['fecha_inicio'] as Timestamp,
      fechaVencimiento: data['fecha_vencimiento'] as Timestamp,
      lote: data['lote'] ?? '',
      precio: (data['precio'] ?? 0.0).toDouble(),
      descripcion: data['descripcion'] ?? '',
      codigo: data['codigo'] ?? '',
      stock: (data['stock'] ?? 0).toInt(),
      esComprado: data['es_comprado'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'fecha_inicio': fechaInicio,
      'fecha_vencimiento': fechaVencimiento,
      'lote': lote,
      'precio': precio,
      'descripcion': descripcion,
      'codigo': codigo,
      'stock': stock,
      'es_comprado': esComprado,
    };
  }

  Future<void> crearProducto() async {
    if (id != null) throw Exception('El producto ya tiene un ID');

    final docRef = FirebaseFirestore.instance.collection('productos').doc();
    id = docRef.id;
    await docRef.set(toFirestore());
  }

  Future<void> actualizarStock(int nuevoStock) async {
    if (id == null) throw Exception('El producto no tiene un ID');

    final docRef = FirebaseFirestore.instance.collection('productos').doc(id);
    await docRef.update({'stock': nuevoStock});
  }

  static Future<Producto> cargarProducto(String productoId) async {
    final docRef = FirebaseFirestore.instance
        .collection('productos')
        .doc(productoId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      return Producto.fromFirestore(docSnapshot);
    } else {
      throw Exception('Producto no encontrado');
    }
  }
}
