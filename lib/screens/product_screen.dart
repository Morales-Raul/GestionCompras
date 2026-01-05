import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clase_4/models/product.dart'; // Importa aquí el modelo Product

// Suponiendo que tienes este helper para los inputs
class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Product product;

  @override
  void initState() {
    super.initState();
    // Clonamos para no modificar el original directamente
    product = widget.product.copy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildTextFormField(
              label: 'Nombre',
              initialValue: product.name,
              onChanged: (value) => setState(() => product.name = value),
              icon: Icons.shopping_bag_outlined,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              label: 'URL Imagen',
              initialValue: product.imageUrl,
              onChanged: (value) => setState(() => product.imageUrl = value),
              icon: Icons.image_outlined,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              label: 'Categoría',
              initialValue: product.category,
              onChanged: (value) => setState(() => product.category = value),
              icon: Icons.category_outlined,
            ),
            const SizedBox(height: 20),

            // Precios Walmart
            _buildPriceFormField(
              label: 'Precio Walmart',
              initialValue: product.prices['Walmart']?.toString() ?? '0.0',
              onChanged: (value) {
                setState(() {
                  product.prices['Walmart'] = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),

            const SizedBox(height: 20),

            SwitchListTile.adaptive(
              value: product.available,
              title: const Text('Disponible'),
              onChanged: (value) {
                setState(() {
                  product.available = value;
                });
              },
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Aquí puedes hacer el guardado, por ejemplo enviar el producto a Firebase
                // O devolver el producto actualizado:
                Navigator.of(context).pop(product);
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecorations.authInputDecoration(
        hintText: label,
        labelText: label,
        prefixIcon: icon,
      ),
    );
  }

  Widget _buildPriceFormField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      onChanged: onChanged,
      decoration: InputDecorations.authInputDecoration(
        hintText: '\$0.00',
        labelText: label,
        prefixIcon: Icons.price_check_outlined,
      ),
    );
  }
}
