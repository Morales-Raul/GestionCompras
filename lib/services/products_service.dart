import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:clase_4/models/product.dart';

class ProductsService extends ChangeNotifier {
  final List<Product> _allProducts = [];
  bool isLoading = true;
  bool isSaving = false;

  late Product selectedProduct;

  String _selectedCategory = 'Todos';

  String get selectedCategory => _selectedCategory;

  // Getter que devuelve productos filtrados por categoría
  List<Product> get products {
    if (_selectedCategory == 'Todos') return _allProducts;
    return _allProducts
        .where(
          (p) => p.category.toLowerCase() == _selectedCategory.toLowerCase(),
        )
        .toList();
  }

  // ✅ Getter público para acceder a todos los productos
  List<Product> get allProducts => _allProducts;

  ProductsService() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(
      'baseflutterumg-default-rtdb.firebaseio.com',
      'productos.json',
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      print('Error al cargar productos: ${response.statusCode}');
      isLoading = false;
      notifyListeners();
      return;
    }

    final data = json.decode(response.body);
    _allProducts.clear();

    if (data is List) {
      for (var i = 0; i < data.length; i++) {
        final value = data[i];
        if (value == null) continue;

        final product = Product(
          id: i.toString(),
          name: value['name'],
          category: value['category'],
          imageUrl: value['imageUrl'],
          available: value['available'],
          prices: Map<String, double>.from(
            (value['prices'] as Map).map(
              (k, v) => MapEntry(k, double.parse(v.toString())),
            ),
          ),
        );
        _allProducts.add(product);
      }
    } else {
      print('Formato inesperado en productos');
    }

    selectedProduct = _allProducts.isNotEmpty
        ? _allProducts.first
        : Product(
            id: '',
            name: '',
            category: '',
            imageUrl: '',
            available: true,
            prices: {},
          );

    isLoading = false;
    notifyListeners();
  }

  Future<void> saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    final productData = {
      'name': product.name,
      'category': product.category,
      'imageUrl': product.imageUrl,
      'available': product.available,
      'prices': product.prices,
    };

    final url = Uri.https(
      'baseflutterumg-default-rtdb.firebaseio.com',
      'productos.json',
    );
    final response = await http.post(url, body: json.encode(productData));
    final decodedData = json.decode(response.body);
    product.id = decodedData['name'];
    _allProducts.add(product);

    isSaving = false;
    notifyListeners();
  }

  Future<String?> uploadImage(File image) async {
    await Future.delayed(Duration(seconds: 2));
    return 'https://fakeurl.com/images/${image.path.split('/').last}';
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSelectedProductImage(String newImageUrl) {
    selectedProduct = selectedProduct.copy();
    selectedProduct.imageUrl = newImageUrl;
    notifyListeners();
  }

  void updateSelectedProduct(Product updatedProduct) {
    selectedProduct = updatedProduct;
    notifyListeners();
  }
}
