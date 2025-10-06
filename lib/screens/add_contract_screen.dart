// CÓDIGO COMPLETO PARA: screens/add_contract_screen.dart

import 'package:flutter/material.dart';

class AddContractScreen extends StatefulWidget {
  final Map<String, dynamic>? contratoInicial;

  const AddContractScreen({super.key, this.contratoInicial});

  @override
  State<AddContractScreen> createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos antigos e novos
  final _numeroController = TextEditingController();
  final _objetoController = TextEditingController();
  final _processoSeiController = TextEditingController();
  final _vigenciaInicioController = TextEditingController();
  final _vigenciaFimController = TextEditingController();
  final _notaEmpenhoController = TextEditingController();
  final _valorContratoController = TextEditingController();
  final _nomeGestorController = TextEditingController();
  final _nomeFiscalController = TextEditingController();
  final _contratadaRazaoSocialController = TextEditingController();
  final _contratadaCnpjController = TextEditingController();

  bool _ehEdicao = false;

  @override
  void initState() {
    super.initState();
    if (widget.contratoInicial != null) {
      _ehEdicao = true;
      _numeroController.text = widget.contratoInicial!['numero'] ?? '';
      _objetoController.text = widget.contratoInicial!['objeto'] ?? '';
      _processoSeiController.text = widget.contratoInicial!['processoSei'] ?? '';
      _vigenciaInicioController.text = widget.contratoInicial!['vigenciaInicio'] ?? '';
      _vigenciaFimController.text = widget.contratoInicial!['vigenciaFim'] ?? '';
      _notaEmpenhoController.text = widget.contratoInicial!['notaEmpenho'] ?? '';
      _valorContratoController.text = widget.contratoInicial!['valorContrato'] ?? '';
      _nomeGestorController.text = widget.contratoInicial!['nomeGestor'] ?? '';
      _nomeFiscalController.text = widget.contratoInicial!['nomeFiscal'] ?? '';
      _contratadaRazaoSocialController.text = widget.contratoInicial!['contratadaRazaoSocial'] ?? '';
      _contratadaCnpjController.text = widget.contratoInicial!['contratadaCnpj'] ?? '';
    }
  }

  @override
  void dispose() {
    // Dispensar todos os controllers
    _numeroController.dispose();
    _objetoController.dispose();
    _processoSeiController.dispose();
    _vigenciaInicioController.dispose();
    _vigenciaFimController.dispose();
    _notaEmpenhoController.dispose();
    _valorContratoController.dispose();
    _nomeGestorController.dispose();
    _nomeFiscalController.dispose();
    _contratadaRazaoSocialController.dispose();
    _contratadaCnpjController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_ehEdicao ? 'Editar Contrato' : 'Adicionar Novo Contrato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          // A tela agora é rolável
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(controller: _numeroController, decoration: const InputDecoration(labelText: 'Número do Contrato', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _objetoController, decoration: const InputDecoration(labelText: 'Objeto do Contrato', border: OutlineInputBorder()), maxLines: 3, validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _processoSeiController, decoration: const InputDecoration(labelText: 'Processo SEI', border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: _valorContratoController, decoration: const InputDecoration(labelText: 'Valor do Contrato (R\$)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                TextFormField(controller: _notaEmpenhoController, decoration: const InputDecoration(labelText: 'Nota de Empenho', border: OutlineInputBorder())),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _vigenciaInicioController, decoration: const InputDecoration(labelText: 'Início da Vigência', border: OutlineInputBorder(), hintText: 'dd/mm/aaaa'))),
                    const SizedBox(width: 16),
                    Expanded(child: TextFormField(controller: _vigenciaFimController, decoration: const InputDecoration(labelText: 'Fim da Vigência', border: OutlineInputBorder(), hintText: 'dd/mm/aaaa'))),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Dados da Contratada', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Divider(),
                const SizedBox(height: 8),
                TextFormField(controller: _contratadaRazaoSocialController, decoration: const InputDecoration(labelText: 'Razão Social', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _contratadaCnpjController, decoration: const InputDecoration(labelText: 'CNPJ', border: OutlineInputBorder())),
                const SizedBox(height: 24),
                const Text('Responsáveis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Divider(),
                const SizedBox(height: 8),
                TextFormField(controller: _nomeGestorController, decoration: const InputDecoration(labelText: 'Nome do Gestor', border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: _nomeFiscalController, decoration: const InputDecoration(labelText: 'Nome do Fiscal', border: OutlineInputBorder())),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final dadosDoContrato = {
                        'numero': _numeroController.text,
                        'objeto': _objetoController.text,
                        'processoSei': _processoSeiController.text,
                        'vigenciaInicio': _vigenciaInicioController.text,
                        'vigenciaFim': _vigenciaFimController.text,
                        'notaEmpenho': _notaEmpenhoController.text,
                        'valorContrato': _valorContratoController.text,
                        'nomeGestor': _nomeGestorController.text,
                        'nomeFiscal': _nomeFiscalController.text,
                        'contratadaRazaoSocial': _contratadaRazaoSocialController.text,
                        'contratadaCnpj': _contratadaCnpjController.text,
                        'status': _ehEdicao ? widget.contratoInicial!['status'] : 'Ativo',
                        'ocorrencias': _ehEdicao ? widget.contratoInicial!['ocorrencias'] : [],
                      };
                      Navigator.pop(context, dadosDoContrato);
                    }
                  },
                  child: Text(_ehEdicao ? 'Salvar Alterações' : 'Salvar Contrato'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}