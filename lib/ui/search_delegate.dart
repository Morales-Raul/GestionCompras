import 'package:clase_4/services/products_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductoSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar productos...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context, listen: false);
    final results = productsService.products
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) {
        final product = results[index];
        final minPrice = product.prices.values.reduce((a, b) => a < b ? a : b);

        return ListTile(
          title: Text(product.name),
          subtitle: Text('Desde: \$${minPrice.toStringAsFixed(2)}'),
          onTap: () {
            productsService.selectedProduct = product;
            Navigator.pushNamed(context, 'product');
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context, listen: false);
    final suggestions = productsService.products
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(product.name),
          onTap: () {
            query = product.name;
            showResults(context);
          },
        );
      },
    );
  }
}
