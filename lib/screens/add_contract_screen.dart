import 'package:flutter/material.dart';

class AddContractScreen extends StatefulWidget {
  // O contrato agora é opcional. Se ele for passado, estamos em modo de edição.
  final Map<String, dynamic>? contratoInicial;

  const AddContractScreen({super.key, this.contratoInicial});

  @override
  State<AddContractScreen> createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numeroController = TextEditingController();
  final _objetoController = TextEditingController();
  final _contratadaController = TextEditingController();

  // Uma variável para saber se estamos editando ou criando
  bool _ehEdicao = false;

  @override
  void initState() {
    super.initState();
    // Se um contrato inicial foi passado, preenchemos os campos
    if (widget.contratoInicial != null) {
      _ehEdicao = true;
      _numeroController.text = widget.contratoInicial!['numero'];
      _objetoController.text = widget.contratoInicial!['objeto'];
      _contratadaController.text = widget.contratoInicial!['contratada'] ?? '';
    }
  }

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
        // O título da tela muda se estamos editando ou criando
        title: Text(_ehEdicao ? 'Editar Contrato' : 'Adicionar Novo Contrato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(labelText: 'Número do Contrato', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Por favor, insira o número' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _objetoController,
                decoration: const InputDecoration(labelText: 'Objeto do Contrato', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Por favor, insira o objeto' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contratadaController,
                decoration: const InputDecoration(labelText: 'Empresa Contratada', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Por favor, insira a empresa' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final dadosDoContrato = {
                      'numero': _numeroController.text,
                      'objeto': _objetoController.text,
                      'contratada': _contratadaController.text, // Adicionamos o novo campo
                      'status': _ehEdicao ? widget.contratoInicial!['status'] : 'Ativo',
                      'ocorrencias': _ehEdicao ? widget.contratoInicial!['ocorrencias'] : [],
                    };
                    // Devolvemos os dados para a tela anterior
                    Navigator.pop(context, dadosDoContrato);
                  }
                },
                child: Text(_ehEdicao ? 'Salvar Alterações' : 'Salvar Contrato'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}