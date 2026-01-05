import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:clase_4/screens/login_screen.dart';
import 'package:clase_4/screens/home_screen.dart';
import 'package:clase_4/screens/product_screen.dart';
import 'package:clase_4/screens/carrito_screen.dart';
import 'package:clase_4/screens/perfil_screen.dart';
import 'package:clase_4/screens/carne_screen.dart';
import 'package:clase_4/screens/ropa_screen.dart';
import 'package:clase_4/screens/dispositivos_screen.dart';
import 'package:clase_4/screens/licores_screen.dart';
import 'package:clase_4/screens/higiene_screen.dart';
import 'package:clase_4/screens/FormularioCompraScreen.dart';
import 'package:clase_4/screens/CompraFinalizadaScreen.dart';

import 'package:clase_4/services/products_service.dart' as service;
import 'package:clase_4/providers/cart_service.dart';
import 'package:clase_4/models/product.dart' as model;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => service.ProductsService()),
        ChangeNotifierProvider(create: (_) => CartService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Comparador de Precios',
        initialRoute: 'home',
        routes: {
          'login': (_) => LoginScreen(),
          'home': (_) => HomeScreen(),
          'carrito': (_) => CarritoScreen(),
          'perfil': (_) => PerfilScreen(),
          'carne': (_) => CarneScreen(),
          'ropa': (_) => RopaScreen(),
          'dispositivos': (_) => DispositivosScreen(),
          'licores': (_) => LicoresScreen(),
          'higiene': (_) => HigieneScreen(),
          'formularioCompra': (_) => FormularioCompraScreen(),
          'compraFinalizada': (_) => CompraFinalizadaScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == 'product') {
            final product = settings.arguments as model.Product;
            return MaterialPageRoute(
              builder: (_) => ProductScreen(product: product),
            );
          }
          return null;
        },
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
        ),
      ),
    );
  }
}
