import 'dart:io';
import 'package:flutter/material.dart';

class OccurrenceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> ocorrencia;

  const OccurrenceDetailScreen({
    super.key,
    required this.ocorrencia,
  });

  @override
  Widget build(BuildContext context) {
    // Pega o caminho da foto dos dados da ocorrência
    final String? fotoPath = ocorrencia['foto_path'];

    return Scaffold(
      appBar: AppBar(
        title: Text(ocorrencia['titulo']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Se existir um caminho para a foto, exibe a imagem
            if (fotoPath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(child: Image.file(File(fotoPath), height: 250)),
              ),
            
            Text('Data do Registro:', style: TextStyle(color: Colors.grey[600])),
            Text(ocorrencia['data']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(height: 32),
            Text('Descrição Completa:', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(ocorrencia['descricao']!, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}