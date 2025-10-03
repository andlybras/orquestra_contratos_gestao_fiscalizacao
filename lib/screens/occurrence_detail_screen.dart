// CÓDIGO COMPLETO PARA: screens/occurrence_detail_screen.dart

import 'package:flutter/material.dart';

class OccurrenceDetailScreen extends StatelessWidget {
  // A tela espera receber os dados da ocorrência selecionada
  final Map<String, dynamic> ocorrencia;

  const OccurrenceDetailScreen({
    super.key,
    required this.ocorrencia,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // O título da tela será o título da ocorrência
        title: Text(ocorrencia['titulo']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data do Registro:',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              ocorrencia['data']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(height: 32),
            Text(
              'Descrição Completa:',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            // Usamos um `Expanded` para que a descrição possa ocupar o espaço necessário
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  ocorrencia['descricao']!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}