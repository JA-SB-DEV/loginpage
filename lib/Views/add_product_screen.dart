import 'dart:math';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Controllers para producto elaborado
  final TextEditingController fechaElaboracionController =
      TextEditingController();
  final TextEditingController fechaVencimientoController =
      TextEditingController();
  final TextEditingController loteController = TextEditingController();
  final TextEditingController cantidadProducidaController =
      TextEditingController();
  final TextEditingController costoController = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();

  // 0 = elaborado, 1 = comprado
  int _selectedType = 0;

  @override
  void initState() {
    super.initState();
    fechaElaboracionController.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    quantityController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    fechaElaboracionController.dispose();
    fechaVencimientoController.dispose();
    loteController.dispose();
    cantidadProducidaController.dispose();
    costoController.dispose();
    observacionesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar producto'),
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: colorScheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: 0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 420,
                  minHeight: constraints.maxHeight * 0.80,
                ),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botones de tipo de producto
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        _selectedType == 0
                                            ? colorScheme.primary
                                            : colorScheme.surfaceVariant,
                                    foregroundColor:
                                        _selectedType == 0
                                            ? Colors.white
                                            : colorScheme.onSurface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: _selectedType == 0 ? 2 : 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedType = 0;
                                    });
                                  },
                                  child: const Text('Elaborado'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        _selectedType == 1
                                            ? colorScheme.primary
                                            : colorScheme.surfaceVariant,
                                    foregroundColor:
                                        _selectedType == 1
                                            ? Colors.white
                                            : colorScheme.onSurface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: _selectedType == 1 ? 2 : 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedType = 1;
                                    });
                                  },
                                  child: const Text('Comprado'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Campos para producto elaborado
                          if (_selectedType == 0) ...[
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Nombre de producto',
                                prefixIcon: Icon(
                                  Icons.label,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Ingrese el nombre'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            // SKU/Código único para producto elaborado
                            TextFormField(
                              controller: codeController,
                              decoration: InputDecoration(
                                labelText: 'SKU o código único',
                                prefixIcon: Icon(
                                  Icons.qr_code,
                                  color: colorScheme.primary,
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.refresh),
                                      tooltip: 'Generar SKU aleatorio',
                                      onPressed: () {
                                        final random = Random();
                                        String randomSku =
                                            List.generate(
                                              25,
                                              (_) =>
                                                  random.nextInt(10).toString(),
                                            ).join();
                                        setState(() {
                                          codeController.text = randomSku;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.qr_code_2),
                                      tooltip: 'Generar QR',
                                      onPressed: () {
                                        if (codeController.text.isNotEmpty) {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: const Text(
                                                    'Código QR del SKU',
                                                  ),
                                                  content: SizedBox(
                                                    width: 200,
                                                    height: 200,
                                                    child: Center(
                                                      child: QrImageView(
                                                        data:
                                                            codeController.text,
                                                        size: 180,
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text(
                                                        'Imprimir',
                                                      ),
                                                      onPressed: () async {
                                                        await Printing.layoutPdf(
                                                          onLayout: (
                                                            format,
                                                          ) async {
                                                            final pdf =
                                                                pw.Document();
                                                            pdf.addPage(
                                                              pw.Page(
                                                                build: (
                                                                  pw.Context
                                                                  context,
                                                                ) {
                                                                  return pw.Center(
                                                                    child: pw.Column(
                                                                      mainAxisSize:
                                                                          pw.MainAxisSize.min,
                                                                      children: [
                                                                        pw.Text(
                                                                          'SKU: ${codeController.text}',
                                                                          style: pw.TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        pw.SizedBox(
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        pw.BarcodeWidget(
                                                                          barcode:
                                                                              pw.Barcode.qrCode(),
                                                                          data:
                                                                              codeController.text,
                                                                          width:
                                                                              180,
                                                                          height:
                                                                              180,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                            return pdf.save();
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                        'Cerrar',
                                                      ),
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Primero ingresa el SKU o código',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Ingrese el SKU o código'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            // Elimina los campos de fecha de elaboración, fecha de vencimiento y cantidad producida
                            TextFormField(
                              controller: loteController,
                              decoration: InputDecoration(
                                labelText: 'Lote',
                                prefixIcon: Icon(
                                  Icons.confirmation_number,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Ingrese el lote'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: costoController,
                              decoration: InputDecoration(
                                labelText: 'Costo',
                                prefixIcon: Icon(
                                  Icons.attach_money,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                              ),
                              keyboardType: TextInputType.number,
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Ingrese el costo'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: observacionesController,
                              decoration: InputDecoration(
                                labelText: 'Observaciones',
                                prefixIcon: Icon(
                                  Icons.description,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                              ),
                              maxLines: 2,
                            ),
                          ],

                          // Campos para producto comprado
                          if (_selectedType == 1) ...[
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Nombre',
                                prefixIcon: Icon(
                                  Icons.label,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Ingrese el nombre'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            // SKU/Código único para producto comprado
                            TextFormField(
                              controller: codeController,
                              decoration: InputDecoration(
                                labelText: 'SKU o código único',
                                prefixIcon: Icon(
                                  Icons.qr_code,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Ingrese el SKU o código'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: quantityController,
                              decoration: InputDecoration(
                                labelText: 'Cantidad',
                                prefixIcon: Icon(
                                  Icons.confirmation_number,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                              ),
                              keyboardType: TextInputType.number,
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Ingrese la cantidad'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: priceController,
                              decoration: InputDecoration(
                                labelText: 'Precio',
                                prefixIcon: Icon(
                                  Icons.attach_money,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                              ),
                              keyboardType: TextInputType.number,
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Ingrese el precio'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Descripción (opcional)',
                                prefixIcon: Icon(
                                  Icons.description,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                              ),
                              maxLines: 2,
                            ),
                          ],

                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.save),
                              label: const Text('Guardar producto'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Aquí puedes guardar el producto en tu base de datos o lista
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Producto agregado'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
