import 'package:flutter/material.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/add_occurrence_screen.dart';

class ContractDetailScreen extends StatefulWidget {
  // O construtor ainda recebe o Map do contrato
  final Map<String, dynamic> contrato;

  const ContractDetailScreen({
    super.key,
    required this.contrato,
  });

  @override
  State<ContractDetailScreen> createState() => _ContractDetailScreenState();
}

class _ContractDetailScreenState extends State<ContractDetailScreen> {
  // A lista de ocorrências agora é uma variável de estado
  late List<Map<String, String>> _ocorrencias;

  @override
  void initState() {
    super.initState();
    // Inicializamos a lista de ocorrências com os dados recebidos do contrato
    // Usamos `List.from` para criar uma cópia modificável da lista.
    _ocorrencias = List.from(widget.contrato['ocorrencias']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contrato['numero']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (informações do contrato que já tínhamos)
            Text('Objeto: ${widget.contrato['objeto']!}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Status: ${widget.contrato['status']!}', style: TextStyle(fontSize: 16)),
            const Divider(height: 40, thickness: 2),

            // Título para a lista de ocorrências
            Text(
              'Ocorrências Registradas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),

            // Lista de ocorrências
            Expanded(
              child: ListView.builder(
                itemCount: _ocorrencias.length,
                itemBuilder: (context, index) {
                  final ocorrencia = _ocorrencias[index];
                  return Card(
                    child: ListTile(
                      title: Text(ocorrencia['titulo']!),
                      subtitle: Text(ocorrencia['descricao']!),
                      trailing: Text(ocorrencia['data']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Botão para adicionar uma nova ocorrência
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaOcorrencia = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddOccurrenceScreen()),
          );

          if (novaOcorrencia != null) {
            setState(() {
              _ocorrencias.add(novaOcorrencia);
            });
          }
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}