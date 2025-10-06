// CÓDIGO COMPLETO PARA: screens/occurrence_detail_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Import do novo pacote de áudio
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class OccurrenceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> ocorrencia;

  const OccurrenceDetailScreen({super.key, required this.ocorrencia});

  @override
  State<OccurrenceDetailScreen> createState() => _OccurrenceDetailScreenState();
}

class _OccurrenceDetailScreenState extends State<OccurrenceDetailScreen> {
  // Controller para o vídeo
  VideoPlayerController? _videoController;
  // NOVO: Player para o áudio
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    final String? videoPath = widget.ocorrencia['video_path'];
    final String? audioPath = widget.ocorrencia['audio_path'];

    // Inicializa o controller do vídeo, se houver um vídeo
    if (videoPath != null) {
      _videoController = VideoPlayerController.file(File(videoPath))
        ..initialize().then((_) {
          setState(() {}); // Redesenha a tela quando o vídeo estiver pronto
        });
    }

    // Prepara o player de áudio, se houver um áudio
    if (audioPath != null) {
      _audioPlayer.setFilePath(audioPath);
    }
  }

  @override
  void dispose() {
    // Dispensa ambos os controllers para liberar recursos
    _videoController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _abrirMapa(double lat, double lon) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (!await launchUrl(url)) {
      throw Exception('Não foi possível abrir o mapa: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? fotoPath = widget.ocorrencia['foto_path'];
    final double? latitude = widget.ocorrencia['latitude'];
    final double? longitude = widget.ocorrencia['longitude'];

    return Scaffold(
      appBar: AppBar(title: Text(widget.ocorrencia['titulo']!)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Seção do Player de Vídeo
          if (_videoController != null && _videoController!.value.isInitialized)
            _buildVideoPlayer(),

          // Seção da Foto
          if (fotoPath != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Image.file(File(fotoPath)),
            ),
          
          const Divider(),
          const Text('Data do Registro:', style: TextStyle(color: Colors.grey)),
          Text(widget.ocorrencia['data']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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

          // NOVO: Seção do Player de Áudio
          if (widget.ocorrencia['audio_path'] != null)
            _buildAudioPlayer(),
          
          const SizedBox(height: 16),
          const Text('Descrição Completa:', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(widget.ocorrencia['descricao']!, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Widget para construir o player de vídeo
  Widget _buildVideoPlayer() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
        IconButton(
          icon: Icon(_videoController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, size: 40),
          onPressed: () => setState(() {
            _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play();
          }),
        ),
        const Divider(),
      ],
    );
  }

  // NOVO WIDGET para construir o player de áudio
  Widget _buildAudioPlayer() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Áudio Anexado', style: TextStyle(fontWeight: FontWeight.bold)),
            // StreamBuilder ouve as mudanças de estado do player (tocando, pausado, etc.)
            // e redesenha o botão automaticamente.
            StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;

                if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                  return const SizedBox(width: 40, height: 40, child: CircularProgressIndicator());
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_arrow, size: 40),
                    onPressed: _audioPlayer.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause, size: 40),
                    onPressed: _audioPlayer.pause,
                  );
                } else {
                  // O áudio terminou, mostra o botão de replay
                  return IconButton(
                    icon: const Icon(Icons.replay, size: 40),
                    onPressed: () => _audioPlayer.seek(Duration.zero),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}