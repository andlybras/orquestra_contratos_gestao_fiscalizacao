// CÓDIGO COMPLETO PARA: screens/add_occurrence_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart'; // Import do novo pacote de áudio
import 'package:path_provider/path_provider.dart'; // Para encontrar o caminho de salvamento

class AddOccurrenceScreen extends StatefulWidget {
  const AddOccurrenceScreen({super.key});

  @override
  State<AddOccurrenceScreen> createState() => _AddOccurrenceScreenState();
}

class _AddOccurrenceScreenState extends State<AddOccurrenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  // Nossas variáveis de estado para as mídias
  XFile? _foto;
  XFile? _video;
  Position? _posicaoGps;
  String? _audioPath;
  bool _isRecording = false;
  final _audioRecorder = AudioRecorder(); // Instância do gravador

  // --- Funções de Captura de Mídia ---

  Future<void> _tirarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? fotoTirada = await picker.pickImage(source: ImageSource.camera);
    if (fotoTirada != null) setState(() => _foto = fotoTirada);
  }

  Future<void> _gravarVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? videoGravado = await picker.pickVideo(source: ImageSource.camera);
    if (videoGravado != null) setState(() => _video = videoGravado);
  }

  Future<void> _obterLocalizacao() async {
    // ... (lógica de permissão do GPS)
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) return Future.error('Serviços de localização desabilitados.');
    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) return Future.error('Permissão de localização negada.');
    }
    if (permissao == LocationPermission.deniedForever) return Future.error('Permissão de localização negada permanentemente.');
    final position = await Geolocator.getCurrentPosition();
    setState(() => _posicaoGps = position);
  }

  Future<void> _gravarAudio() async {
    if (await _audioRecorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/audio_ocorrencia_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _audioRecorder.start(const RecordConfig(), path: path);
      setState(() {
        _isRecording = true;
        _audioPath = null; // Limpa o áudio anterior
      });
    }
  }

  Future<void> _pararGravacao() async {
    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
      _audioPath = path;
    });
  }


  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _audioRecorder.dispose(); // Não se esqueça de dispensar o gravador!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Ocorrência')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título da Ocorrência', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Insira um título' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição Detalhada', border: OutlineInputBorder()),
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty ? 'Insira uma descrição' : null,
                ),
                const SizedBox(height: 24),

                // --- Seção de Evidências ---
                Text('Anexar Evidências', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),

                Wrap( // Wrap organiza os botões quebrando a linha se não couber
                  spacing: 8.0,
                  runSpacing: 4.0,
                  alignment: WrapAlignment.center,
                  children: [
                    OutlinedButton.icon(onPressed: _tirarFoto, icon: const Icon(Icons.camera_alt), label: const Text('Foto')),
                    OutlinedButton.icon(onPressed: _gravarVideo, icon: const Icon(Icons.videocam), label: const Text('Vídeo')),
                    // Botão de áudio muda de aparência se estiver gravando
                    _isRecording
                      ? FilledButton.icon(onPressed: _pararGravacao, icon: const Icon(Icons.stop), label: const Text('Parar Gravação'), style: FilledButton.styleFrom(backgroundColor: Colors.red))
                      : OutlinedButton.icon(onPressed: _gravarAudio, icon: const Icon(Icons.mic), label: const Text('Áudio')),
                    OutlinedButton.icon(onPressed: _obterLocalizacao, icon: const Icon(Icons.location_on), label: const Text('GPS')),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Indicadores de Anexos ---
                if (_foto != null) ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Foto anexada')),
                if (_video != null) ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Vídeo anexado')),
                if (_audioPath != null) ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Áudio anexado')),
                if (_posicaoGps != null) ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('GPS capturado')),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final agora = DateTime.now();
                      final formatador = DateFormat('dd/MM/yyyy HH:mm:ss');
                      final dataFormatada = formatador.format(agora);

                      final novaOcorrencia = {
                        'titulo': _tituloController.text,
                        'descricao': _descricaoController.text,
                        'data': dataFormatada,
                        'foto_path': _foto?.path,
                        'video_path': _video?.path,
                        'audio_path': _audioPath,
                        'latitude': _posicaoGps?.latitude,
                        'longitude': _posicaoGps?.longitude,
                      };
                      Navigator.pop(context, novaOcorrencia);
                    }
                  },
                  child: const Text('Salvar Ocorrência'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}