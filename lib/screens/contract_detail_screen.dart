import 'package:flutter/material.dart';

class ContractDetailScreen extends StatelessWidget {
  // 1. A tela declara que precisa receber um 'Map' de contrato para funcionar.
  final Map<String, String> contrato;

  // 2. O construtor exige que o 'contrato' seja passado ao criar a tela.
  const ContractDetailScreen({
    super.key,
    required this.contrato,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 3. O título da tela usa o dado recebido do contrato.
        title: Text(contrato['numero']!),
      ),
      // 4. Exibimos os detalhes do contrato no corpo da tela.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha o texto à esquerda
          children: [
            Text(
              'Objeto:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contrato['objeto']!,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              'Status:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contrato['status']!,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}