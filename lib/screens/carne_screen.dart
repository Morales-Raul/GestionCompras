import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clase_4/services/products_service.dart';
import 'package:clase_4/providers/cart_service.dart';

class CarneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final productsService = Provider.of<ProductsService>(context);

    final productos = productsService.products
        .where((p) => p.category.toLowerCase().contains('carne'))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carne'),
        backgroundColor: Colors.red.shade700,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(context, 'carrito'),
              ),
              if (cartService.products.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: CircleAvatar(
                    backgroundColor: Colors.red.shade900,
                    radius: 10,
                    child: Text(
                      '${cartService.products.length}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: productos.isEmpty
          ? Center(child: Text('No hay productos de carne disponibles.'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: productos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final producto = productos[index];

                  // 👌 calcular precio mínimo entre supermercados
                  final minPrice = producto.prices.values.reduce(
                    (value, element) => value < element ? value : element,
                  );

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          child: producto.imageUrl.isNotEmpty
                              ? Image.network(
                                  producto.imageUrl,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 120,
                                  color: Colors.grey[300],
                                  child:
                                      Icon(Icons.image_not_supported, size: 60),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          child: Column(
                            children: [
                              Text(
                                producto.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Desde Q${minPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.green.shade700),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  cartService.addProduct(producto);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${producto.name} agregado al carrito'),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(12),
                                  backgroundColor: Colors.red.shade700,
                                ),
                                child: Icon(Icons.add_shopping_cart,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
