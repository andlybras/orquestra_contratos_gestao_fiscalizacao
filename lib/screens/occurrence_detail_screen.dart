// CÓDIGO CORRIGIDO PARA: screens/occurrence_detail_screen.dart
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
    final String? fotoPath = ocorrencia['foto_path'];
    final double? latitude = ocorrencia['latitude'];
    final double? longitude = ocorrencia['longitude'];

    return Scaffold(
      appBar: AppBar(
        title: Text(ocorrencia['titulo']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView( // Usamos ListView para garantir que tudo caiba na tela
          children: [
            if (fotoPath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(child: Image.file(File(fotoPath), height: 250)),
              ),
            
            const Text('Data do Registro:', style: TextStyle(color: Colors.grey)),
            Text(ocorrencia['data']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),

            // EXIBIÇÃO DO GPS
            if (latitude != null && longitude != null) ...[
              const Text('Geolocalização:', style: TextStyle(color: Colors.grey)),
              Text('Lat: $latitude, Lon: $longitude', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
            ],

            const Divider(),
            const SizedBox(height: 16),
            
            const Text('Descrição Completa:', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),

            // EXIBIÇÃO DA DESCRIÇÃO
            Text(ocorrencia['descricao']!, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}