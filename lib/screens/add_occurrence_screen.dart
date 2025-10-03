import 'package:flutter/material.dart';

class AddOccurrenceScreen extends StatefulWidget {
  const AddOccurrenceScreen({super.key});

  @override
  State<AddOccurrenceScreen> createState() => _AddOccurrenceScreenState();
}

class _AddOccurrenceScreenState extends State<AddOccurrenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

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
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título da Ocorrência',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição Detalhada',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5, // Permite um campo de texto maior
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final novaOcorrencia = {
                      'titulo': _tituloController.text,
                      'descricao': _descricaoController.text,
                      'data': '03/10/2025', // Usaremos uma data fixa por enquanto
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
    );
  }
}