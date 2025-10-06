// CÓDIGO COMPLETO PARA: screens/contract_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/add_occurrence_screen.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/occurrence_detail_screen.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/services/report_service.dart';

class ContractDetailScreen extends StatefulWidget {
  final Map<String, dynamic> contrato;
  final Function(List<dynamic>) onUpdate;

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
  final _reportService = ReportService();

  @override
  void initState() {
    super.initState();
    _ocorrencias = List.from(widget.contrato['ocorrencias'] ?? []);
  }

  Icon _getIconForOccurrenceType(String? tipo) {
    switch (tipo) {
      case 'Vistoria/Acompanhamento':
        return const Icon(Icons.visibility);
      case 'Recebimento Provisório':
        return const Icon(Icons.inventory_2_outlined);
      case 'Recebimento Definitivo':
        return const Icon(Icons.inventory);
      case 'Atesto de Nota Fiscal':
        return const Icon(Icons.receipt_long);
      case 'Irregularidade/Pendência':
        return const Icon(Icons.warning, color: Colors.orange);
      default:
        return const Icon(Icons.comment);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> gestores = widget.contrato['gestores'] ?? [];
    final List<dynamic> fiscais = widget.contrato['fiscais'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contrato['numero'] ?? 'Detalhes do Contrato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Relatório do Contrato (PDF)',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gerando relatório...')));
              _reportService.gerarRelatorioParaContratoUnico(widget.contrato);
            },
          ),
          IconButton(
            icon: const Icon(Icons.archive),
            tooltip: 'Dossiê do Contrato (.zip)',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gerando Dossiê .zip...')));
              _reportService.gerarDossieParaContratoUnico(widget.contrato);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Detalhes Gerais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildDetailRow('Processo SEI', widget.contrato['processoSei']),
          _buildDetailRow('Objeto', widget.contrato['objeto']),
          _buildDetailRow('Valor', 'R\$ ${widget.contrato['valorContrato'] ?? ''}'),
          _buildDetailRow('Nota de Empenho', widget.contrato['notaEmpenho']),
          _buildDetailRow('Vigência', '${widget.contrato['vigenciaInicio'] ?? ''} a ${widget.contrato['vigenciaFim'] ?? ''}'),
          _buildDetailRow('Status', widget.contrato['status']),
          const SizedBox(height: 24),
          const Text('Contratada', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildDetailRow('Razão Social', widget.contrato['contratadaRazaoSocial']),
          _buildDetailRow('CNPJ', widget.contrato['contratadaCnpj']),
          const SizedBox(height: 24),
          const Text('Responsáveis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          const Text('Gestores:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...gestores.map((gestor) => Card(
                child: ListTile(
                  title: Text(gestor['nome'] ?? 'Nome não informado'),
                  subtitle: Text('CPF: ${gestor['cpf'] ?? ''} | Portaria: ${gestor['portaria'] ?? ''}'),
                ),
              )).toList(),
          const SizedBox(height: 16),
          const Text('Fiscais:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...fiscais.map((fiscal) => Card(
                child: ListTile(
                  title: Text(fiscal['nome'] ?? 'Nome não informado'),
                  subtitle: Text('CPF: ${fiscal['cpf'] ?? ''} | Portaria: ${fiscal['portaria'] ?? ''}'),
                ),
              )).toList(),
          const Divider(height: 40, thickness: 2),
          const Text('Ocorrências Registradas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 16),
          _ocorrencias.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Nenhuma ocorrência registrada para este contrato.'),
                )
              : Column(
                  children: _ocorrencias.map((ocorrencia) {
                    return Card(
                      child: ListTile(
                        leading: _getIconForOccurrenceType(ocorrencia['tipo']),
                        title: Text(ocorrencia['titulo']!),
                        subtitle: Text(ocorrencia['tipo'] ?? 'Ocorrência'),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OccurrenceDetailScreen(ocorrencia: ocorrencia),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
        ],
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
              widget.onUpdate(_ocorrencias);
            });
          }
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}