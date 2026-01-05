import 'package:clase_4/providers/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarritoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final totals = cartService.getTotalBySupermarket();
    final selectedStore = cartService.selectedStore;
    final cartProducts = cartService.products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Selecciona el supermercado para la compra:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: totals.keys.map((store) {
                final isSelected = store == selectedStore;
                return GestureDetector(
                  onTap: () {
                    cartService.selectStore(store);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.indigo : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          store,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '\Q${totals[store]!.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Lista de productos en el carrito
            Expanded(
              child: cartProducts.isEmpty
                  ? Center(child: Text('No hay productos en el carrito.'))
                  : ListView.builder(
                      itemCount: cartProducts.length,
                      itemBuilder: (context, index) {
                        final product = cartProducts[index];
                        final price = product.prices[selectedStore] ?? 0.0;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Image.network(
                                  product.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Icon(Icons.image_not_supported),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(product.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(
                                          'Precio en $selectedStore: \Q${price.toStringAsFixed(2)}'),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Total: \Q${(price * product.quantity).toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon:
                                              Icon(Icons.remove_circle_outline),
                                          onPressed: () => cartService
                                              .decreaseQuantity(product),
                                        ),
                                        Text('${product.quantity}'),
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.green,
                                          ),
                                          onPressed: () => cartService
                                              .increaseQuantity(product),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 16),

            Text(
              'Total a pagar en $selectedStore',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              '\Q${cartService.calculateTotalPrice().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              icon: Icon(Icons.arrow_forward),
              label: Text('Continuar al formulario de compra'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                if (cartService.products.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('El carrito está vacío')),
                  );
                  return;
                }
                Navigator.pushNamed(context, 'formularioCompra');
              },
            ),
          ],
        ),
      ),
    );
  }
}
