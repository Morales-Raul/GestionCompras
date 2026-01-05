import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo.shade200,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            SizedBox(height: 20),

            Text(
              'Usuario Demo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text('usuario@correo.com', style: TextStyle(color: Colors.grey)),

            SizedBox(height: 30),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                // Lógica para configuración
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Ayuda'),
              onTap: () {
                // Lógica para ayuda
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
