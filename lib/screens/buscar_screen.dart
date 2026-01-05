import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/products_service.dart';
import '../providers/cart_service.dart'; // <-- Importa CartService

class BuscarScreen extends StatefulWidget {
  @override
  _BuscarScreenState createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final cartService = Provider.of<CartService>(context,
        listen: false); // <-- Obtener CartService
    final allProducts = productsService.allProducts;

    final filteredProducts = allProducts
        .where((product) =>
            product.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar productos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => searchTerm = value),
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text('No se encontraron productos.'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      String? cheapestStore;
                      double? cheapestPrice;
                      product.prices.forEach((store, price) {
                        if (cheapestPrice == null || price < cheapestPrice!) {
                          cheapestStore = store;
                          cheapestPrice = price;
                        }
                      });

                      return ListTile(
                        leading: Image.network(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.image_not_supported),
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          cheapestPrice != null
                              ? 'Desde Q${cheapestPrice!.toStringAsFixed(2)} en $cheapestStore'
                              : 'Sin precio disponible',
                        ),
                        trailing: Icon(
                            Icons.add_shopping_cart), // <-- Ícono de carrito
                        onTap: () {
                          cartService
                              .addProduct(product); // <-- Agregar al carrito
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${product.name} añadido al carrito'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
