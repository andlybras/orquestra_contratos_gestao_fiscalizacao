import 'package:flutter/material.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/add_contract_screen.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/contract_detail_screen.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _listaDeContratos = [];
  final _databaseService = DatabaseService();

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

  // NOVA FUNÇÃO: Navegar para a tela de adicionar/editar
  void _navegarParaAdicionarEditarContrato({Map<String, dynamic>? contrato, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddContractScreen(contratoInicial: contrato)),
    ).then((dadosRetornados) {
      if (dadosRetornados != null) {
        setState(() {
          if (index != null) {
            // Modo Edição: substitui o contrato no índice especificado
            _listaDeContratos[index] = dadosRetornados;
          } else {
            // Modo Adição: adiciona um novo contrato à lista
            _listaDeContratos.add(dadosRetornados);
          }
        });
        _salvarDados();
      }
    });
  }

  // NOVA FUNÇÃO: Mostrar menu de opções
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
                Navigator.pop(context); // Fecha o dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContractDetailScreen(contrato: contrato, onUpdate: _salvarDados)),
                );
              },
              child: const Text('Ver Detalhes'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context); // Fecha o dialog
                _navegarParaAdicionarEditarContrato(contrato: contrato, index: index);
              },
              child: const Text('Editar'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context); // Fecha o dialog
                _confirmarExclusao(context, index);
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // NOVA FUNÇÃO: Confirmar exclusão
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
              trailing: const Icon(Icons.more_vert), // Ícone de 3 pontinhos
              onTap: () => _mostrarOpcoes(context, index), // Ação onTap agora mostra o menu
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
      // ... sua lista de exemplo ...
    ];
  }
}