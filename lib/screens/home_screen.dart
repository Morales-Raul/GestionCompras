import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:clase_4/screens/buscar_screen.dart';
import 'package:clase_4/screens/carne_screen.dart';
import 'package:clase_4/screens/dispositivos_screen.dart';
import 'package:clase_4/screens/higiene_screen.dart';
import 'package:clase_4/screens/licores_screen.dart';
import 'package:clase_4/screens/ropa_screen.dart';
import 'package:clase_4/screens/carrito_screen.dart';
import 'package:clase_4/screens/perfil_screen.dart';
import 'package:clase_4/services/products_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {
      'icon': '🥩',
      'label': 'Carne',
      'route': CarneScreen(),
      'color': const Color.fromARGB(255, 254, 221, 221)
    },
    {
      'icon': '📱',
      'label': 'Dispositivos',
      'route': DispositivosScreen(),
      'color': const Color.fromARGB(255, 217, 247, 241)
    },
    {
      'icon': '👗',
      'label': 'Ropa',
      'route': RopaScreen(),
      'color': const Color.fromARGB(255, 248, 211, 224)
    },
    {
      'icon': '🧼',
      'label': 'Higiene',
      'route': HigieneScreen(),
      'color': const Color.fromARGB(255, 163, 251, 241)
    },
    {
      'icon': '🍷',
      'label': 'Licores',
      'route': LicoresScreen(),
      'color': const Color.fromARGB(255, 248, 249, 208)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      drawer: _Sidebar(),
      body: SafeArea(
        child: _buildSelectedScreen(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Para ti'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Buscar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Carrito de compras'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: 'Usuario'),
        ],
      ),
    );
  }

  Widget _buildSelectedScreen(int index) {
    final productsService = Provider.of<ProductsService>(context);

    switch (index) {
      case 0:
        return _buildHomeContent(productsService);
      case 1:
        return BuscarScreen();
      case 2:
        return CarritoScreen();
      case 3:
        return PerfilScreen();
      default:
        return Center(child: Text('Pantalla desconocida'));
    }
  }

  Widget _buildHomeContent(ProductsService productsService) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Encuentra tus productos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2.5,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                final bool isSelected =
                    productsService.selectedCategory == category['label'];
                return GestureDetector(
                  onTap: () {
                    productsService.selectCategory(category['label']);
                    if (category['route'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => category['route']),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: category['color'],
                      borderRadius: BorderRadius.circular(50),
                      border: isSelected
                          ? Border.all(color: Colors.indigo, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category['icon'],
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['label'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Center(
              child: Text(
                'Categorías',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          _drawerItem(context, '🥩 Carne', 'Carne', CarneScreen()),
          _drawerItem(
              context, '📱 Dispositivos', 'Dispositivos', DispositivosScreen()),
          _drawerItem(context, '👗 Ropa', 'Ropa', RopaScreen()),
          _drawerItem(context, '🧼 Higiene', 'Higiene', HigieneScreen()),
          _drawerItem(context, '🍷 Licores', 'Licores', LicoresScreen()),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, String title, String category, Widget? screen) {
    return ListTile(
      title: Text(title),
      onTap: () {
        final productsService =
            Provider.of<ProductsService>(context, listen: false);
        productsService.selectCategory(category);
        Navigator.pop(context);
        if (screen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        }
      },
    );
  }
}
