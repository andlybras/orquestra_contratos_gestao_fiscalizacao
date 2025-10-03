import 'package:flutter/material.dart';

class AddContractScreen extends StatefulWidget {
  const AddContractScreen({super.key});

  @override
  State<AddContractScreen> createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  final _formKey = GlobalKey<FormState>();

  // 1. Declarando os "secretários" (Controllers) para cada campo.
  final _numeroController = TextEditingController();
  final _objetoController = TextEditingController();
  final _contratadaController = TextEditingController();

  // 2. É uma boa prática "dispensar" os controllers quando a tela é destruída
  // para liberar a memória que eles usam.
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
              // 3. Anexando o controller ao seu respectivo campo de texto.
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(
                  labelText: 'Número do Contrato',
                  border: OutlineInputBorder(),
                ),
                // 4. Adicionando uma regra de validação simples.
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
                  // 5. Ação ao pressionar o botão "Salvar".
                  if (_formKey.currentState!.validate()) {
                    // Se o formulário for válido, mostramos os dados no console.
                    print('Formulário Válido!');
                    print('Número: ${_numeroController.text}');
                    print('Objeto: ${_objetoController.text}');
                    print('Contratada: ${_contratadaController.text}');
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