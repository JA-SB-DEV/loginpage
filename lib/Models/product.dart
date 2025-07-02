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

  Producto({
    this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaVencimiento,
    required this.lote,
    required this.precio,
    required this.descripcion,
    required this.codigo,
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
    };
  }

  // Método para crear un nuevo producto en Firestore
  Future<void> crearProducto() async {
    if (id != null) throw Exception('El producto ya tiene un ID');

    final docRef = FirebaseFirestore.instance.collection('productos').doc();
    id = docRef.id;
    await docRef.set(toFirestore());
  }

  // Método para actualizar un producto existente
  Future<void> actualizarProducto() async {
    if (id == null) throw Exception('El producto no tiene un ID');

    final docRef = FirebaseFirestore.instance.collection('productos').doc(id);
    await docRef.update(toFirestore());
  }

  // Método para cargar un producto desde Firestore
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
