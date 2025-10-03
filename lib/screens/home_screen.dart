// Precisamos importar o pacote Material aqui também!
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Este é exatamente o mesmo Scaffold que tínhamos antes.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orquestra Contratos'),
      ),
      body: const Center(
        child: Text(
          'Gestão e Fiscalização',
        ),
      ),
    );
  }
}