import 'package:flutter/material.dart';

class AddContractScreen extends StatefulWidget {
  const AddContractScreen({super.key});

  @override
  State<AddContractScreen> createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  final _formKey = GlobalKey<FormState>();

  final _numeroController = TextEditingController();
  final _objetoController = TextEditingController();
  final _contratadaController = TextEditingController();

  @override
  void dispose() {
    _numeroController.dispose();
    _objetoController.dispose();
    _contratadaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo Contrato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(
                  labelText: 'Número do Contrato',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número do contrato';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _objetoController,
                decoration: const InputDecoration(
                  labelText: 'Objeto do Contrato',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o objeto do contrato';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _contratadaController,
                decoration: const InputDecoration(
                  labelText: 'Empresa Contratada',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da empresa';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Ação ao pressionar o botão "Salvar".
                  if (_formKey.currentState!.validate()) {
                    // 1. Cria um Map com os dados do novo contrato.
                    final novoContrato = {
                      'numero': _numeroController.text,
                      'objeto': _objetoController.text,
                      'status': 'Ativo',
                      'ocorrencias': [], // A LINHA QUE FALTAVA!
                    };

                    // 2. Fecha a tela e "devolve" o novoContrato como resultado.
                    Navigator.pop(context, novoContrato);
                  }
                },
                child: const Text('Salvar Contrato'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}