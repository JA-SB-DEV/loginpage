import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          return Colors.green;
        case 'Bajo':
          return Colors.orange;
        case 'Agotado':
          return Colors.red;
        default:
          return colorScheme.primary;
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Agregar producto'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
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
                                              color: getStatusColor(
                                                product['estado'],
                                              ).withOpacity(0.13),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              product['categoria'] == 'Insumo'
                                                  ? Icons.kitchen
                                                  : Icons.bakery_dining,
                                              color: getStatusColor(
                                                product['estado'],
                                              ),
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
                                                  color: getStatusColor(
                                                    product['estado'],
                                                  ).withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '${product['stock']}',
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: getStatusColor(
                                                      product['estado'],
                                                    ),
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
                                                  color: getStatusColor(
                                                    product['estado'],
                                                  ).withOpacity(0.18),
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
                                                  // Aquí puedes manejar las acciones
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
