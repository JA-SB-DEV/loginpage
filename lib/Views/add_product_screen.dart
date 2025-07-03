import 'dart:math';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:loginpage/Controllers/product_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final ProductoController _productoController = ProductoController();

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

  DateTime _parseDate(String date) {
    final parts = date.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
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
                            // Nombre
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
                            // Código
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
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              12,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color:
                                                                colorScheme
                                                                    .primary,
                                                            width: 3,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: colorScheme
                                                                  .primary
                                                                  .withOpacity(
                                                                    0.15,
                                                                  ),
                                                              blurRadius: 8,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    4,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: QrImageView(
                                                          data:
                                                              codeController
                                                                  .text,
                                                          size: 180,
                                                          backgroundColor:
                                                              Colors.white,
                                                          eyeStyle:
                                                              const QrEyeStyle(
                                                                eyeShape:
                                                                    QrEyeShape
                                                                        .square,
                                                                color:
                                                                    Colors
                                                                        .black87, // Cambia el color de los "ojos" del QR
                                                              ),
                                                          dataModuleStyle:
                                                              const QrDataModuleStyle(
                                                                dataModuleShape:
                                                                    QrDataModuleShape
                                                                        .circle,
                                                                color:
                                                                    Colors
                                                                        .black, // Cambia el color de los puntos del QR
                                                              ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        'SKU: ${codeController.text}',
                                                        style: TextStyle(
                                                          color:
                                                              colorScheme
                                                                  .primary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
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
                            // Fecha de elaboración
                            TextFormField(
                              controller: fechaElaboracionController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Fecha de elaboración',
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed:
                                      () => _selectDate(
                                        context,
                                        fechaElaboracionController,
                                      ),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Seleccione la fecha de elaboración'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            // Fecha de vencimiento
                            TextFormField(
                              controller: fechaVencimientoController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Fecha de vencimiento',
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed:
                                      () => _selectDate(
                                        context,
                                        fechaVencimientoController,
                                      ),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Seleccione la fecha de vencimiento'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            // Lote
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
                              keyboardType:
                                  TextInputType.number, // Solo números
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Ingrese el lote';
                                if (int.tryParse(value) == null)
                                  return 'El lote debe ser numérico';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            // Stock
                            TextFormField(
                              controller: quantityController,
                              decoration: InputDecoration(
                                labelText: 'Stock',
                                prefixIcon: Icon(
                                  Icons.storage,
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
                                          ? 'Ingrese el stock'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            // Precio
                            TextFormField(
                              controller: costoController,
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
                            // Observaciones
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
                            // Nombre
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
                            // Código
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
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              12,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color:
                                                                colorScheme
                                                                    .primary,
                                                            width: 3,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: colorScheme
                                                                  .primary
                                                                  .withOpacity(
                                                                    0.15,
                                                                  ),
                                                              blurRadius: 8,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    4,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: QrImageView(
                                                          data:
                                                              codeController
                                                                  .text,
                                                          size: 180,
                                                          backgroundColor:
                                                              Colors.white,
                                                          eyeStyle:
                                                              const QrEyeStyle(
                                                                eyeShape:
                                                                    QrEyeShape
                                                                        .square,
                                                                color:
                                                                    Colors
                                                                        .blue, // Cambia el color de los "ojos" del QR
                                                              ),
                                                          dataModuleStyle:
                                                              const QrDataModuleStyle(
                                                                dataModuleShape:
                                                                    QrDataModuleShape
                                                                        .circle,
                                                                color:
                                                                    Colors
                                                                        .black, // Cambia el color de los puntos del QR
                                                              ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        'SKU: ${codeController.text}',
                                                        style: TextStyle(
                                                          color:
                                                              colorScheme
                                                                  .primary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
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
                            // Fecha de compra
                            TextFormField(
                              controller:
                                  fechaElaboracionController, // Puedes renombrar el controller si lo deseas
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Fecha de compra',
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed:
                                      () => _selectDate(
                                        context,
                                        fechaElaboracionController,
                                      ),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Seleccione la fecha de compra'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            // Fecha de vencimiento
                            TextFormField(
                              controller: fechaVencimientoController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Fecha de vencimiento',
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(isDark ? 0.18 : 0.85),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed:
                                      () => _selectDate(
                                        context,
                                        fechaVencimientoController,
                                      ),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Seleccione la fecha de vencimiento'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            // Lote
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
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Ingrese el lote';
                                if (int.tryParse(value) == null)
                                  return 'El lote debe ser numérico';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            // Stock
                            TextFormField(
                              controller: quantityController,
                              decoration: InputDecoration(
                                labelText: 'Stock',
                                prefixIcon: Icon(
                                  Icons.storage,
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
                                          ? 'Ingrese el stock'
                                          : null,
                            ),
                            const SizedBox(height: 14),
                            // Precio
                            TextFormField(
                              controller: costoController,
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
                            // Observaciones
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    // Convierte fechas a Timestamp
                                    DateTime fecha1 =
                                        _selectedType == 0
                                            ? _parseDate(
                                              fechaElaboracionController.text,
                                            )
                                            : _parseDate(
                                              fechaElaboracionController.text,
                                            ); // Para compra
                                    DateTime fecha2 = _parseDate(
                                      fechaVencimientoController.text,
                                    );

                                    await _productoController.crearProducto(
                                      nombre: nameController.text,
                                      fechaInicio: Timestamp.fromDate(fecha1),
                                      fechaVencimiento: Timestamp.fromDate(
                                        fecha2,
                                      ),
                                      lote: loteController.text,
                                      precio: double.parse(
                                        costoController.text,
                                      ),
                                      descripcion: observacionesController.text,
                                      codigo: codeController.text,
                                      stock: int.parse(quantityController.text),
                                      esComprado:
                                          _selectedType == 1 ? true : false,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Producto agregado exitosamente',
                                        ),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error al guardar: $e'),
                                      ),
                                    );
                                  }
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
