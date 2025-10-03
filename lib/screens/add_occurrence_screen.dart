import 'dart:io'; // Import necessário para trabalhar com arquivos (File)
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import do novo pacote

class AddOccurrenceScreen extends StatefulWidget {
  const AddOccurrenceScreen({super.key});

  @override
  State<AddOccurrenceScreen> createState() => _AddOccurrenceScreenState();
}

class _AddOccurrenceScreenState extends State<AddOccurrenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  // Variável para guardar o caminho da foto tirada
  XFile? _foto;

  Future<void> _tirarFoto() async {
    final ImagePicker picker = ImagePicker();
    // Abre a câmera do dispositivo
    final XFile? fotoTirada = await picker.pickImage(source: ImageSource.camera);

    if (fotoTirada != null) {
      setState(() {
        _foto = fotoTirada;
      });
    }
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
      appBar: AppBar(
        title: const Text('Registrar Ocorrência'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Usamos para evitar que o teclado cubra os campos
            child: Column(
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Insira um título' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty ? 'Insira uma descrição' : null,
                ),
                const SizedBox(height: 16),
                
                // Exibição da prévia da foto
                if (_foto != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.file(File(_foto!.path), height: 200),
                  ),

                // Botão para tirar a foto
                OutlinedButton.icon(
                  onPressed: _tirarFoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Adicionar Foto'),
                ),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final novaOcorrencia = {
                        'titulo': _tituloController.text,
                        'descricao': _descricaoController.text,
                        'data': '03/10/2025',
                        // Adicionamos o caminho da foto aos dados
                        'foto_path': _foto?.path,
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