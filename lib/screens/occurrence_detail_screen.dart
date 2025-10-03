// CÓDIGO COMPLETO PARA: screens/occurrence_detail_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OccurrenceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> ocorrencia;

  const OccurrenceDetailScreen({super.key, required this.ocorrencia});

  Future<void> _abrirMapa(double lat, double lon) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (!await launchUrl(url)) {
      throw Exception('Não foi possível abrir o mapa: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? fotoPath = ocorrencia['foto_path'];
    final String? videoPath = ocorrencia['video_path'];
    final String? audioPath = ocorrencia['audio_path'];
    final double? latitude = ocorrencia['latitude'];
    final double? longitude = ocorrencia['longitude'];

    return Scaffold(
      appBar: AppBar(title: Text(ocorrencia['titulo']!)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (fotoPath != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Image.file(File(fotoPath)),
            ),
          
          const Text('Data do Registro:', style: TextStyle(color: Colors.grey)),
          Text(ocorrencia['data']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),

          if (latitude != null && longitude != null) ...[
            const Text('Geolocalização:', style: TextStyle(color: Colors.grey)),
            InkWell(
              onTap: () => _abrirMapa(latitude, longitude),
              child: Text(
                'Lat: $latitude, Lon: $longitude (Toque para ver no mapa)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 16),
          ],

          const Divider(),
          const SizedBox(height: 8),

          // Seção de Anexos
          if (videoPath != null || audioPath != null) ...[
            const Text('Outros Anexos:', style: TextStyle(color: Colors.grey)),
            if (videoPath != null)
              ListTile(leading: const Icon(Icons.videocam), title: const Text('Vídeo anexado'), subtitle: Text(videoPath), dense: true),
            if (audioPath != null)
              ListTile(leading: const Icon(Icons.mic), title: const Text('Áudio anexado'), subtitle: Text(audioPath), dense: true),
            const SizedBox(height: 8),
            const Divider(),
          ],
          
          const SizedBox(height: 16),
          const Text('Descrição Completa:', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(ocorrencia['descricao']!, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}