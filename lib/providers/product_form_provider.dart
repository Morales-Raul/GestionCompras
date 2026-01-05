import 'package:flutter/material.dart';
import 'package:clase_4/models/product.dart';

class ProductFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Product product;

  ProductFormProvider(Product? initialProduct) {
    if (initialProduct == null) {
      product = Product(
        id: '',
        name: '',
        imageUrl: '',
        category: '',
        available: true,
        prices: {
          '': 0.0,
        },
      );
    } else {
      product = initialProduct;
    }
  }

  void updateAvailability(bool value) {
    product.available = value;
    notifyListeners();
  }

  void updatePrice(String supermarket, double value) {
    product.prices[supermarket] = value;
    notifyListeners();
  }

  bool isValidForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    formKey.currentState?.save();
    return true;
  }
}
