import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import do pacote de geolocalização
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import do pacote de formatação de data

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
  Position? _posicaoGps; // Variável para guardar as coordenadas

  // Função para capturar a foto
  Future<void> _tirarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? fotoTirada = await picker.pickImage(source: ImageSource.camera);
    if (fotoTirada != null) {
      setState(() => _foto = fotoTirada);
    }
  }

  // NOVA FUNÇÃO para obter a geolocalização
  Future<void> _obterLocalizacao() async {
    bool servicoHabilitado;
    LocationPermission permissao;

    servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      return Future.error('Serviços de localização estão desabilitados.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Permissão de localização negada.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Permissão de localização permanentemente negada.');
    }

    // Se tudo deu certo, obtemos a posição
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _posicaoGps = position;
    });
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
                TextFormField(/* ... campo de título sem alterações ... */),
                const SizedBox(height: 16),
                TextFormField(/* ... campo de descrição sem alterações ... */),
                const SizedBox(height: 16),
                if (_foto != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.file(File(_foto!.path), height: 200),
                  ),

                // Exibição da geolocalização capturada
                if (_posicaoGps != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Localização: Lat ${_posicaoGps!.latitude.toStringAsFixed(5)}, Lon ${_posicaoGps!.longitude.toStringAsFixed(5)}',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ),

                // Botões de Ação para evidências
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
                      // Capturamos a data e hora ATUAIS no momento do salvamento
                      final agora = DateTime.now();
                      final formatador = DateFormat('dd/MM/yyyy HH:mm:ss');
                      final dataFormatada = formatador.format(agora);

                      final novaOcorrencia = {
                        'titulo': _tituloController.text,
                        'descricao': _descricaoController.text,
                        'data': dataFormatada, // Data e hora automáticas!
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