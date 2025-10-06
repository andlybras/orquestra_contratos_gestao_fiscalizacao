// CÓDIGO COMPLETO PARA: screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/add_contract_screen.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/contract_detail_screen.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/services/database_service.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/services/report_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _listaDeContratos = [];
  final _databaseService = DatabaseService();
  final _reportService = ReportService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    final contratosSalvos = await _databaseService.carregarContratos();
    if (mounted) {
      setState(() {
        _listaDeContratos = contratosSalvos;
        _isLoading = false;
      });
    }
  }

  Future<void> _salvarDados() async {
    await _databaseService.salvarContratos(_listaDeContratos);
  }

  void _navegarParaAdicionarEditarContrato({Map<String, dynamic>? contrato, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddContractScreen(contratoInicial: contrato)),
    ).then((dadosRetornados) {
      if (dadosRetornados != null) {
        // A estrutura dos dados retornados agora é muito mais rica,
        // mas a lógica de adicionar ou editar a lista principal não muda.
        setState(() {
          if (index != null) {
            _listaDeContratos[index] = dadosRetornados;
          } else {
            // A estrutura de um novo contrato agora inclui listas vazias
            // para gestores, fiscais, documentos, etc.
            _listaDeContratos.add(dadosRetornados);
          }
        });
        _salvarDados();
      }
    });
  }

  void _mostrarOpcoes(BuildContext context, int index) {
    final contrato = _listaDeContratos[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(contrato['numero']!),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContractDetailScreen(
                      contrato: contrato,
                      onUpdate: (novasOcorrencias) {
                        setState(() {
                          _listaDeContratos[index]['ocorrencias'] = novasOcorrencias;
                        });
                        _salvarDados();
                      },
                    ),
                  ),
                );
              },
              child: const Text('Ver Detalhes'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _navegarParaAdicionarEditarContrato(contrato: contrato, index: index);
              },
              child: const Text('Editar'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _confirmarExclusao(context, index);
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _confirmarExclusao(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja excluir este contrato?'),
          actions: <Widget>[
            TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() => _listaDeContratos.removeAt(index));
                _salvarDados();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orquestra Contratos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Relatório Geral (PDF)',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gerando relatório...')));
              _reportService.gerarRelatorioPDF(_listaDeContratos);
            },
          ),
          IconButton(
            icon: const Icon(Icons.archive),
            tooltip: 'Dossiê Geral (.zip)',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gerando Dossiê .zip...')));
              _reportService.gerarDossieCompleto(_listaDeContratos);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listaDeContratos.isEmpty
              ? const Center(
                  child: Text('Nenhum contrato cadastrado.\nClique no botão + para começar.', textAlign: TextAlign.center),
                )
              : ListView.builder(
                  itemCount: _listaDeContratos.length,
                  itemBuilder: (context, index) {
                    final contrato = _listaDeContratos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.article),
                        title: Text(contrato['numero'] ?? 'Sem número'),
                        // Exibindo a razão social da contratada no subtítulo
                        subtitle: Text(contrato['contratadaRazaoSocial'] ?? 'Sem objeto'),
                        trailing: const Icon(Icons.more_vert),
                        onTap: () => _mostrarOpcoes(context, index),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarParaAdicionarEditarContrato(),
        child: const Icon(Icons.add),
      ),
    );
  }
}