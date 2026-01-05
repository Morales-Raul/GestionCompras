import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clase_4/providers/cart_service.dart';

class FormularioCompraScreen extends StatefulWidget {
  const FormularioCompraScreen({super.key});

  @override
  State<FormularioCompraScreen> createState() => _FormularioCompraScreenState();
}

class _FormularioCompraScreenState extends State<FormularioCompraScreen> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String correo = '';
  String direccion = '';
  String metodoPago = 'Tarjeta de crédito';

  final List<String> metodosPago = [
    'Tarjeta de crédito',
    'Tarjeta de débito',
    'Pago contra entrega',
    'Transferencia bancaria',
  ];

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Detalles de Compra')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Completa tus datos:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              // Nombre
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Nombre completo', border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
                onSaved: (value) => nombre = value!,
              ),
              SizedBox(height: 16),

              // Correo
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.contains('@') ? null : 'Correo inválido',
                onSaved: (value) => correo = value!,
              ),
              SizedBox(height: 16),

              // Dirección
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Dirección de entrega',
                    border: OutlineInputBorder()),
                maxLines: 2,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
                onSaved: (value) => direccion = value!,
              ),
              SizedBox(height: 16),

              // Método de pago
              DropdownButtonFormField<String>(
                value: metodoPago,
                decoration: InputDecoration(
                    labelText: 'Método de pago', border: OutlineInputBorder()),
                items: metodosPago
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => metodoPago = value!),
              ),
              SizedBox(height: 30),

              // Botón Confirmar
              ElevatedButton.icon(
                icon: Icon(Icons.check),
                label: Text('Confirmar compra'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 188, 196, 236),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    cartService.clearCart();

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      'compraFinalizada',
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
