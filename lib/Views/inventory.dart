import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'qr_scanner_page.dart'; // Importa tu nueva pantalla

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    final List<Map<String, dynamic>> products = [
      {
        'nombre': 'Harina de trigo',
        'sku': 'SKU1234567890',
        'stock': 25,
        'minimo': 10,
        'categoria': 'Insumo',
        'estado': 'Disponible',
      },
      {
        'nombre': 'Azúcar refinada',
        'sku': 'SKU0987654321',
        'stock': 8,
        'minimo': 10,
        'categoria': 'Insumo',
        'estado': 'Bajo',
      },
      {
        'nombre': 'Pan integral',
        'sku': 'SKU1122334455',
        'stock': 0,
        'minimo': 5,
        'categoria': 'Producto elaborado',
        'estado': 'Agotado',
      },
    ];

    Color getStatusColor(String estado) {
      switch (estado) {
        case 'Disponible':
          return colorScheme.secondary; // Suave, no neón
        case 'Bajo':
          return colorScheme.tertiary ?? Colors.amber.shade700;
        case 'Agotado':
          return colorScheme.error.withOpacity(0.85);
        default:
          return colorScheme.primary;
      }
    }

    Color getStatusBgColor(String estado) {
      switch (estado) {
        case 'Disponible':
          return colorScheme.secondary.withOpacity(0.13);
        case 'Bajo':
          return (colorScheme.tertiary ?? Colors.amber).withOpacity(0.13);
        case 'Agotado':
          return colorScheme.error.withOpacity(0.13);
        default:
          return colorScheme.primary.withOpacity(0.13);
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Inventario',
          style: GoogleFonts.inter(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: isDesktop ? 26 : 22,
            letterSpacing: 1,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              // Acción para agregar producto
            },
            icon: const Icon(Icons.add),
            label: const Text('Agregar producto'),
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            heroTag: 'add_product',
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              final qrResult = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QrScannerPage()),
              );
              if (qrResult != null) {
                final product = products.firstWhere(
                  (p) => p['sku'] == qrResult,
                  orElse: () => <String, dynamic>{},
                );
                if (product != null) {
                  // Muestra detalles del producto
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Text(
                              product['nombre'],
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Text('SKU: ${product['sku']}'),
                            Text('Categoría: ${product['categoria']}'),
                            Text('Stock actual: ${product['stock']}'),
                            Text('Stock mínimo: ${product['minimo']}'),
                            Text('Estado: ${product['estado']}'),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: const Text('Cerrar'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Producto no encontrado para este QR'),
                    ),
                  );
                }
              }
            },
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            heroTag: 'scan_qr',
            child: const Icon(Icons.qr_code_scanner),
            tooltip: 'Escanear QR',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 900 : 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar producto, SKU o categoría',
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorScheme.primary,
                      ),
                      filled: true,
                      fillColor: colorScheme.surface.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child:
                        products.isEmpty
                            ? Center(
                              child: Text(
                                'No hay productos en inventario.',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            )
                            : ListView.separated(
                              padding: const EdgeInsets.only(bottom: 90),
                              itemCount: products.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return Material(
                                  color: colorScheme.surface,
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(18),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: () {
                                      // Acción al tocar la tarjeta
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: colorScheme.primary
                                                  .withOpacity(0.10),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              product['categoria'] == 'Insumo'
                                                  ? Icons.kitchen
                                                  : Icons.bakery_dining,
                                              color: colorScheme.primary,
                                              size: 30,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product['nombre'],
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'SKU: ${product['sku']}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13,
                                                    color: colorScheme.onSurface
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                                Text(
                                                  'Categoría: ${product['categoria']}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13,
                                                    color: colorScheme.onSurface
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: colorScheme.primary
                                                      .withOpacity(0.10),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '${product['stock']}',
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: colorScheme.primary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: getStatusBgColor(
                                                    product['estado'],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  product['estado'],
                                                  style: GoogleFonts.inter(
                                                    color: getStatusColor(
                                                      product['estado'],
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuButton<String>(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: colorScheme.primary,
                                                ),
                                                itemBuilder:
                                                    (context) => [
                                                      const PopupMenuItem(
                                                        value: 'ver',
                                                        child: Text(
                                                          'Ver detalles',
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 'editar',
                                                        child: Text('Editar'),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 'eliminar',
                                                        child: Text('Eliminar'),
                                                      ),
                                                    ],
                                                onSelected: (value) {
                                                  if (value == 'ver') {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                              top:
                                                                  Radius.circular(
                                                                    20,
                                                                  ),
                                                            ),
                                                      ),
                                                      builder: (_) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                24,
                                                              ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Center(
                                                                child: Container(
                                                                  width: 40,
                                                                  height: 4,
                                                                  margin:
                                                                      const EdgeInsets.only(
                                                                        bottom:
                                                                            16,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                        Colors
                                                                            .grey[400],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          2,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                product['nombre'],
                                                                style: GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              Text(
                                                                'SKU: ${product['sku']}',
                                                                style:
                                                                    GoogleFonts.inter(
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                              ),
                                                              Text(
                                                                'Categoría: ${product['categoria']}',
                                                                style:
                                                                    GoogleFonts.inter(
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                              ),
                                                              Text(
                                                                'Stock actual: ${product['stock']}',
                                                                style:
                                                                    GoogleFonts.inter(
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                              ),
                                                              Text(
                                                                'Stock mínimo: ${product['minimo']}',
                                                                style:
                                                                    GoogleFonts.inter(
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                              ),
                                                              Text(
                                                                'Estado: ${product['estado']}',
                                                                style:
                                                                    GoogleFonts.inter(
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .centerRight,
                                                                child: TextButton(
                                                                  child:
                                                                      const Text(
                                                                        'Cerrar',
                                                                      ),
                                                                  onPressed:
                                                                      () => Navigator.pop(
                                                                        context,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else if (value ==
                                                      'editar') {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                              top:
                                                                  Radius.circular(
                                                                    20,
                                                                  ),
                                                            ),
                                                      ),
                                                      builder: (_) {
                                                        final nombreController =
                                                            TextEditingController(
                                                              text:
                                                                  product['nombre'],
                                                            );
                                                        final skuController =
                                                            TextEditingController(
                                                              text:
                                                                  product['sku'],
                                                            );
                                                        final stockController =
                                                            TextEditingController(
                                                              text:
                                                                  product['stock']
                                                                      .toString(),
                                                            );
                                                        final minimoController =
                                                            TextEditingController(
                                                              text:
                                                                  product['minimo']
                                                                      .toString(),
                                                            );
                                                        return GestureDetector(
                                                          onTap:
                                                              () =>
                                                                  FocusScope.of(
                                                                    context,
                                                                  ).unfocus(),
                                                          child: DraggableScrollableSheet(
                                                            expand: false,
                                                            initialChildSize:
                                                                0.65,
                                                            minChildSize: 0.4,
                                                            maxChildSize: 0.85,
                                                            builder: (
                                                              context,
                                                              scrollController,
                                                            ) {
                                                              return SingleChildScrollView(
                                                                controller:
                                                                    scrollController,
                                                                padding: EdgeInsets.only(
                                                                  left: 24,
                                                                  right: 24,
                                                                  top: 24,
                                                                  bottom:
                                                                      MediaQuery.of(
                                                                        context,
                                                                      ).viewInsets.bottom +
                                                                      24,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Center(
                                                                      child: Container(
                                                                        width:
                                                                            40,
                                                                        height:
                                                                            4,
                                                                        margin: const EdgeInsets.only(
                                                                          bottom:
                                                                              18,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              Colors.grey[400],
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                2,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Editar producto',
                                                                      style: GoogleFonts.inter(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            22,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          18,
                                                                    ),
                                                                    TextField(
                                                                      controller:
                                                                          nombreController,
                                                                      decoration: InputDecoration(
                                                                        labelText:
                                                                            'Nombre',
                                                                        filled:
                                                                            true,
                                                                        fillColor: Theme.of(
                                                                          context,
                                                                        ).colorScheme.surface.withOpacity(
                                                                          0.9,
                                                                        ),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                        ),
                                                                        contentPadding: const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              14,
                                                                          vertical:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          14,
                                                                    ),
                                                                    TextField(
                                                                      controller:
                                                                          skuController,
                                                                      decoration: InputDecoration(
                                                                        labelText:
                                                                            'SKU',
                                                                        filled:
                                                                            true,
                                                                        fillColor: Theme.of(
                                                                          context,
                                                                        ).colorScheme.surface.withOpacity(
                                                                          0.9,
                                                                        ),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                        ),
                                                                        contentPadding: const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              14,
                                                                          vertical:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          14,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: TextField(
                                                                            controller:
                                                                                stockController,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            decoration: InputDecoration(
                                                                              labelText:
                                                                                  'Stock actual',
                                                                              filled:
                                                                                  true,
                                                                              fillColor: Theme.of(
                                                                                context,
                                                                              ).colorScheme.surface.withOpacity(
                                                                                0.9,
                                                                              ),
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  12,
                                                                                ),
                                                                              ),
                                                                              contentPadding: const EdgeInsets.symmetric(
                                                                                horizontal:
                                                                                    14,
                                                                                vertical:
                                                                                    12,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              12,
                                                                        ),
                                                                        Expanded(
                                                                          child: TextField(
                                                                            controller:
                                                                                minimoController,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            decoration: InputDecoration(
                                                                              labelText:
                                                                                  'Stock mínimo',
                                                                              filled:
                                                                                  true,
                                                                              fillColor: Theme.of(
                                                                                context,
                                                                              ).colorScheme.surface.withOpacity(
                                                                                0.9,
                                                                              ),
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  12,
                                                                                ),
                                                                              ),
                                                                              contentPadding: const EdgeInsets.symmetric(
                                                                                horizontal:
                                                                                    14,
                                                                                vertical:
                                                                                    12,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          18,
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child: ElevatedButton.icon(
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .save,
                                                                        ),
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor:
                                                                              Theme.of(
                                                                                context,
                                                                              ).colorScheme.primary,
                                                                          foregroundColor:
                                                                              Colors.white,
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                          ),
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                24,
                                                                            vertical:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                        label: const Text(
                                                                          'Guardar',
                                                                        ),
                                                                        onPressed: () {
                                                                          // Aquí puedes guardar los cambios
                                                                          Navigator.pop(
                                                                            context,
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                  // Aquí puedes manejar 'eliminar' si lo deseas
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
