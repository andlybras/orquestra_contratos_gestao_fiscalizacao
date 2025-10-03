import 'package:flutter/material.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/add_contract_screen.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/contract_detail_screen.dart';

// 1. Convertemos para StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 2. A lista de contratos agora faz parte do Estado, para que possa ser modificada.
  final List<Map<String, String>> _listaDeContratos = [
    {
      'numero': 'Contrato Nº 123/2025',
      'objeto': 'Serviço de manutenção predial',
      'status': 'Ativo',
    },
    {
      'numero': 'Contrato Nº 456/2025',
      'objeto': 'Aquisição de equipamentos de TI',
      'status': 'Ativo',
    },
    {
      'numero': 'Contrato Nº 789/2024',
      'objeto': 'Fornecimento de material de expediente',
      'status': 'Encerrado',
    },
  ];

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
              // 5. Modificando a ação `onTap`
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContractDetailScreen(
                      // 6. Passando o 'contrato' daquele item da lista para a nova tela.
                      contrato: contrato,
                    ),
                  ),
                );
              },
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async { // 3. A função onPressed agora é `async`
          // 4. `await` espera a tela AddContractScreen ser fechada e nos dá o resultado.
          final novoContrato = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContractScreen()),
          );

          // 5. Se o usuário salvou (e não apenas voltou), `novoContrato` não será nulo.
          if (novoContrato != null) {
            // 6. `setState` é o comando que avisa o Flutter para redesenhar a tela!
            setState(() {
              _listaDeContratos.add(novoContrato);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}