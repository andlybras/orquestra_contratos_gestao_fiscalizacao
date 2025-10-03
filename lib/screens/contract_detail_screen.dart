// CÓDIGO COMPLETO PARA: screens/contract_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/add_occurrence_screen.dart';
// Import que faltava para a nova tela:
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/occurrence_detail_screen.dart';

class ContractDetailScreen extends StatefulWidget {
  final Map<String, dynamic> contrato;
  final Function onUpdate;

  const ContractDetailScreen({
    super.key,
    required this.contrato,
    required this.onUpdate,
  });

  @override
  State<ContractDetailScreen> createState() => _ContractDetailScreenState();
}

class _ContractDetailScreenState extends State<ContractDetailScreen> {
  late List<dynamic> _ocorrencias;

  @override
  void initState() {
    super.initState();
    _ocorrencias = List.from(widget.contrato['ocorrencias'] ?? []);
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
            Text('Objeto: ${widget.contrato['objeto']!}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Status: ${widget.contrato['status']!}', style: const TextStyle(fontSize: 16)),
            const Divider(height: 40, thickness: 2),
            const Text(
              'Ocorrências Registradas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _ocorrencias.length,
                itemBuilder: (context, index) {
                  final ocorrencia = _ocorrencias[index];
                  return Card(
                    child: ListTile(
                      title: Text(ocorrencia['titulo']!),
                      subtitle: Text(
                        ocorrencia['descricao']!,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(ocorrencia['data']!),
                      // Ação de toque para ir para a tela de detalhes da ocorrência
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OccurrenceDetailScreen(
                              ocorrencia: ocorrencia,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaOcorrencia = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddOccurrenceScreen()),
          );

          if (novaOcorrencia != null) {
            setState(() {
              _ocorrencias.add(novaOcorrencia);
              widget.onUpdate();
            });
          }
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}