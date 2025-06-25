import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({super.key});

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock de envíos
  final List<Map<String, String>> _allShipments = [
    {'codigo': '1001', 'destinatario': 'Cliente 1', 'estado': 'En tránsito'},
    {'codigo': '1002', 'destinatario': 'Cliente 2', 'estado': 'Entregado'},
    {'codigo': '1003', 'destinatario': 'Cliente 3', 'estado': 'Pendiente'},
  ];

  List<Map<String, String>> _filteredShipments = [];

  @override
  void initState() {
    super.initState();
    _filteredShipments = List.from(_allShipments);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredShipments =
          _allShipments.where((shipment) {
            return shipment['destinatario']!.toLowerCase().contains(query) ||
                shipment['codigo']!.toLowerCase().contains(query);
          }).toList();
    });
  }

  void _showFilterDialog() async {
    String? selectedEstado;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrar por estado'),
          content: DropdownButtonFormField<String>(
            value: selectedEstado,
            items: const [
              DropdownMenuItem(
                value: 'En tránsito',
                child: Text('En tránsito'),
              ),
              DropdownMenuItem(value: 'Entregado', child: Text('Entregado')),
              DropdownMenuItem(value: 'Pendiente', child: Text('Pendiente')),
            ],
            onChanged: (value) {
              selectedEstado = value;
            },
            decoration: const InputDecoration(labelText: 'Estado'),
          ),
          actions: [
            TextButton(
              child: const Text('Limpiar'),
              onPressed: () {
                setState(() {
                  _filteredShipments = List.from(_allShipments);
                });
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Aplicar'),
              onPressed: () {
                if (selectedEstado != null) {
                  setState(() {
                    _filteredShipments =
                        _allShipments
                            .where(
                              (shipment) =>
                                  shipment['estado'] == selectedEstado,
                            )
                            .toList();
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Envíos',
          style: GoogleFonts.inter(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.local_shipping),
        label: const Text('Nuevo envío'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filtros de búsqueda
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar por destinatario o código',
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorScheme.primary,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.filter_alt, color: colorScheme.primary),
                  onPressed: _showFilterDialog,
                  tooltip: 'Filtrar',
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Lista de envíos filtrados
            Expanded(
              child:
                  _filteredShipments.isEmpty
                      ? Center(
                        child: Text(
                          'No hay envíos para mostrar.',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      )
                      : ListView.separated(
                        itemCount: _filteredShipments.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final shipment = _filteredShipments[index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            color: colorScheme.surface,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: colorScheme.primary
                                    .withOpacity(0.15),
                                child: Icon(
                                  Icons.local_shipping,
                                  color: colorScheme.primary,
                                ),
                              ),
                              title: Text(
                                'Envío #${shipment['codigo']}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Destinatario: ${shipment['destinatario']}',
                                    style: GoogleFonts.inter(fontSize: 13),
                                  ),
                                  Text(
                                    'Estado: ${shipment['estado']}',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color:
                                          shipment['estado'] == 'Entregado'
                                              ? Colors.green
                                              : shipment['estado'] ==
                                                  'En tránsito'
                                              ? Colors.orange
                                              : Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: colorScheme.primary,
                              ),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
