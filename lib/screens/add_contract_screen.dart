// CÓDIGO COMPLETO PARA: screens/add_contract_screen.dart

import 'package:flutter/material.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/responsible_management_screen.dart';

class AddContractScreen extends StatefulWidget {
  // O contrato agora é opcional. Se ele for passado, estamos em modo de edição.
  final Map<String, dynamic>? contratoInicial;

  const AddContractScreen({super.key, this.contratoInicial});

  @override
  State<AddContractScreen> createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos de texto
  final _numeroController = TextEditingController();
  final _objetoController = TextEditingController();
  final _processoSeiController = TextEditingController();
  final _vigenciaInicioController = TextEditingController();
  final _vigenciaFimController = TextEditingController();
  final _notaEmpenhoController = TextEditingController();
  final _valorContratoController = TextEditingController();
  final _contratadaRazaoSocialController = TextEditingController();
  final _contratadaCnpjController = TextEditingController();

  // As listas de gestores e fiscais agora são parte do estado do formulário
  List<Map<String, dynamic>> _gestores = [];
  List<Map<String, dynamic>> _fiscais = [];

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
      _contratadaRazaoSocialController.text = widget.contratoInicial!['contratadaRazaoSocial'] ?? '';
      _contratadaCnpjController.text = widget.contratoInicial!['contratadaCnpj'] ?? '';

      // Preenche as listas de gestores e fiscais com os dados existentes
      if (widget.contratoInicial!['gestores'] != null) {
        _gestores = List<Map<String, dynamic>>.from(widget.contratoInicial!['gestores']);
      }
      if (widget.contratoInicial!['fiscais'] != null) {
        _fiscais = List<Map<String, dynamic>>.from(widget.contratoInicial!['fiscais']);
      }
    }
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _objetoController.dispose();
    _processoSeiController.dispose();
    _vigenciaInicioController.dispose();
    _vigenciaFimController.dispose();
    _notaEmpenhoController.dispose();
    _valorContratoController.dispose();
    _contratadaRazaoSocialController.dispose();
    _contratadaCnpjController.dispose();
    super.dispose();
  }

  // Função para navegar para a tela de gerenciamento
  void _gerenciarResponsaveis(String tipo) async {
    final listaInicial = tipo == 'Gestores' ? _gestores : _fiscais;
    
    final listaAtualizada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResponsibleManagementScreen(
          responsaveisIniciais: listaInicial,
          titulo: 'Gerenciar $tipo',
        ),
      ),
    );

    if (listaAtualizada != null) {
      setState(() {
        if (tipo == 'Gestores') {
          _gestores = listaAtualizada;
        } else {
          _fiscais = listaAtualizada;
        }
      });
    }
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
                
                // Botão para gerenciar Gestores
                ListTile(
                  leading: const Icon(Icons.manage_accounts),
                  title: const Text('Gestores'),
                  subtitle: Text('${_gestores.length} gestor(es) definido(s)'),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _gerenciarResponsaveis('Gestores'),
                ),

                // Botão para gerenciar Fiscais
                ListTile(
                  leading: const Icon(Icons.person_search),
                  title: const Text('Fiscais'),
                  subtitle: Text('${_fiscais.length} fiscal(is) definido(s)'),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _gerenciarResponsaveis('Fiscais'),
                ),

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
                        'contratadaRazaoSocial': _contratadaRazaoSocialController.text,
                        'contratadaCnpj': _contratadaCnpjController.text,
                        
                        // Adicionando as listas ao mapa de dados
                        'gestores': _gestores,
                        'fiscais': _fiscais,

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