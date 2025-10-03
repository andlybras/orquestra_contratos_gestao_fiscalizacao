import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 1. Nossos dados de exemplo (mock data).
  // No futuro, esta lista virá de um banco de dados.
  final List<Map<String, String>> _listaDeContratos = const [
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
      // 2. ListView.builder: O construtor de listas do Flutter.
      body: ListView.builder(
        // `itemCount` diz à lista quantos itens ela precisa construir.
        itemCount: _listaDeContratos.length,
        // `itemBuilder` é a "receita" para construir cada item da lista.
        itemBuilder: (context, index) {
          final contrato = _listaDeContratos[index];
          // 3. Card: Um widget que cria um "cartão" com elevação e bordas arredondadas.
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              // 4. ListTile: Um widget de linha de lista pré-estilizado.
              leading: const Icon(Icons.article), // Ícone à esquerda
              title: Text(contrato['numero']!), // Título principal
              subtitle: Text(contrato['objeto']!), // Subtítulo
              trailing: const Icon(Icons.arrow_forward_ios), // Ícone à direita
              onTap: () {
                // Ação a ser executada quando o item for tocado (no futuro).
                print('Contrato selecionado: ${contrato['numero']}');
              },
            ),
          );
        },
      ),
      // 5. FloatingActionButton: O botão de ação flutuante.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação para adicionar um novo contrato (no futuro).
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}