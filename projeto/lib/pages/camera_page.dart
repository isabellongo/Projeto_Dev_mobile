import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.go('/notes'), // Volta à tela anterior
        ),
      ),
      body: Center(
        child: IconButton(
          iconSize: 80,
          icon: const Icon(Icons.camera_alt, color: Colors.white),
          onPressed: () {
            // Aqui futuramente você chamaria a função da câmera
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Simulando foto...')),
            );
          },
        ),
      ),
    );
  }
}