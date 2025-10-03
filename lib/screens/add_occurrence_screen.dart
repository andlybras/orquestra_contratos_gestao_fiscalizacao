// CÓDIGO CORRIGIDO PARA: screens/add_occurrence_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddOccurrenceScreen extends StatefulWidget {
  const AddOccurrenceScreen({super.key});

  @override
  State<AddOccurrenceScreen> createState() => _AddOccurrenceScreenState();
}

class _AddOccurrenceScreenState extends State<AddOccurrenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  XFile? _foto;
  Position? _posicaoGps;

  Future<void> _tirarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? fotoTirada = await picker.pickImage(source: ImageSource.camera);
    if (fotoTirada != null) {
      setState(() => _foto = fotoTirada);
    }
  }

  Future<void> _obterLocalizacao() async {
    // ... (lógica de permissão e captura do GPS que já está funcionando)
    bool servicoHabilitado;
    LocationPermission permissao;

    servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) return Future.error('Serviços de localização desabilitados.');

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) return Future.error('Permissão de localização negada.');
    }

    if (permissao == LocationPermission.deniedForever) return Future.error('Permissão de localização negada permanentemente.');

    final position = await Geolocator.getCurrentPosition();
    setState(() => _posicaoGps = position);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
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
              children: [
                // DECORAÇÃO ADICIONADA DE VOLTA
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título da Ocorrência', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Insira um título' : null,
                ),
                const SizedBox(height: 16),
                // DECORAÇÃO ADICIONADA DE VOLTA
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição Detalhada', border: OutlineInputBorder()),
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty ? 'Insira uma descrição' : null,
                ),
                const SizedBox(height: 16),

                if (_foto != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.file(File(_foto!.path), height: 200),
                  ),

                if (_posicaoGps != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Localização: Lat ${_posicaoGps!.latitude.toStringAsFixed(5)}, Lon ${_posicaoGps!.longitude.toStringAsFixed(5)}',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(onPressed: _tirarFoto, icon: const Icon(Icons.camera_alt), label: const Text('Foto')),
                    OutlinedButton.icon(onPressed: _obterLocalizacao, icon: const Icon(Icons.location_on), label: const Text('GPS')),
                  ],
                ),
                
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