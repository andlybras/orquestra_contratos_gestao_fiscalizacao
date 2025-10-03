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
  // A lista agora começa vazia e será preenchida com os dados salvos.
  List<Map<String, dynamic>> _listaDeContratos = [];
  final _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _carregarDados(); // Chamamos o método para carregar os dados quando a tela inicia.
  }

  // Método para carregar os dados do serviço
  Future<void> _carregarDados() async {
    final contratosSalvos = await _databaseService.carregarContratos();
    // Se não houver dados salvos, usamos a lista de exemplo inicial.
    if (contratosSalvos.isEmpty) {
      setState(() {
        _listaDeContratos = _getListaInicial();
      });
    } else {
      setState(() {
        _listaDeContratos = contratosSalvos;
      });
    }
  }

  // Método para salvar os dados usando o serviço
  Future<void> _salvarDados() async {
    await _databaseService.salvarContratos(_listaDeContratos);
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
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContractDetailScreen(
                      contrato: contrato,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novoContrato = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContractScreen()),
          );

          if (novoContrato != null) {
            setState(() {
              _listaDeContratos.add(novoContrato);
            });
            await _salvarDados(); // SALVA a lista atualizada!
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // A lista de exemplo agora fica em um método separado.
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