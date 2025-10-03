// CÓDIGO COMPLETO PARA: screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/add_contract_screen.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/contract_detail_screen.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/services/database_service.dart';
// Importamos nosso novo serviço de relatório
import 'package:orquestra_contratos_gestao_fiscalizacao/services/report_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _listaDeContratos = [];
  final _databaseService = DatabaseService();
  // Criamos uma instância do nosso serviço de relatório
  final _reportService = ReportService();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final contratosSalvos = await _databaseService.carregarContratos();
    if (contratosSalvos.isEmpty && mounted) {
      setState(() => _listaDeContratos = _getListaInicial());
    } else if (mounted) {
      setState(() => _listaDeContratos = contratosSalvos);
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
        setState(() {
          if (index != null) {
            _listaDeContratos[index] = dadosRetornados;
          } else {
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
          content: const Text('Você tem certeza que deseja excluir este contrato e todas as suas ocorrências?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _listaDeContratos.removeAt(index);
                });
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
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          // Botão para gerar o PDF (pré-visualização)
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Pré-visualizar Relatório PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gerando pré-visualização do relatório...')),
              );
              _reportService.gerarRelatorioPDF(_listaDeContratos);
            },
          ),
          // NOVO BOTÃO para gerar o Dossiê ZIP
          IconButton(
            icon: const Icon(Icons.archive),
            tooltip: 'Exportar Dossiê Completo (.zip)',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gerando Dossiê .zip...')),
              );
              _reportService.gerarDossieCompleto(_listaDeContratos);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _listaDeContratos.length,
        itemBuilder: (context, index) {
          final contrato = _listaDeContratos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.article),
              title: Text(contrato['numero']!),
              subtitle: Text(contrato['objeto']!),
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

  List<Map<String, dynamic>> _getListaInicial() {
    return [
      {
        'numero': 'Contrato Nº 123/2025',
        'objeto': 'Serviço de manutenção predial',
        'status': 'Ativo',
        'ocorrencias': [
          {'titulo': 'Vistoria inicial', 'descricao': 'Tudo conforme o esperado.', 'data': '28/09/2025'}
        ]
      },
      {
        'numero': 'Contrato Nº 456/2025',
        'objeto': 'Aquisição de equipamentos de TI',
        'status': 'Ativo',
        'ocorrencias': []
      },
    ];
  }
}