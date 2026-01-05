import 'package:flutter/material.dart';
import 'package:clase_4/models/product.dart';

class CartService extends ChangeNotifier {
  List<Product> _products = [];

  // Supermercado seleccionado para comprar
  String _selectedStore = '';

  List<Product> get products => _products;

  String get selectedStore => _selectedStore;

  void addProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index].quantity++;
    } else {
      product.quantity = 1;
      _products.add(product);
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _products.clear();
    notifyListeners();
  }

  // Cambiar supermercado seleccionado
  void selectStore(String store) {
    if (_selectedStore != store) {
      _selectedStore = store;
      notifyListeners();
    }
  }

  // Obtener totales por supermercado
  Map<String, double> getTotalBySupermarket() {
    Map<String, double> totals = {};

    for (var product in _products) {
      product.prices.forEach((supermarket, price) {
        totals[supermarket] =
            (totals[supermarket] ?? 0) + price * product.quantity;
      });
    }
    return totals;
  }

  // Total según supermercado seleccionado
  double calculateTotalPrice() {
    double total = 0;
    for (var product in _products) {
      total += (product.prices[_selectedStore] ?? 0) * product.quantity;
    }
    return total;
  }

  String getCheapestSupermarket() {
    final totals = getTotalBySupermarket();
    String cheapest = totals.keys.first;
    double minPrice = totals[cheapest]!;

    totals.forEach((supermarket, price) {
      if (price < minPrice) {
        cheapest = supermarket;
        minPrice = price;
      }
    });
    return cheapest;
  }

  void increaseQuantity(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1 && _products[index].quantity > 1) {
      _products[index].quantity--;
      notifyListeners();
    } else if (index != -1) {
      removeProduct(product); // Elimina si llega a 0
    }
  }
}
