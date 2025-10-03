// CÓDIGO NOVO E SIMPLIFICADO PARA: services/report_service.dart

import 'package:flutter/services.dart'; // Usaremos para carregar a fonte
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // O pacote principal que usaremos agora
import 'package:intl/intl.dart';

class ReportService {
  Future<void> gerarRelatorioPDF(List<Map<String, dynamic>> contratos) async {
    // Cria o documento PDF da mesma forma que antes
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _construirCabecalho(),
            pw.Divider(),
            pw.SizedBox(height: 20),
            for (final contrato in contratos) ...[
              _construirSecaoContrato(contrato),
              pw.SizedBox(height: 15),
              _construirListaOcorrencias(contrato['ocorrencias']),
              pw.Divider(height: 30),
            ],
          ];
        },
      ),
    );

    // A GRANDE MUDANÇA ESTÁ AQUI:
    // Em vez de salvar e abrir manualmente, usamos o Printing.layoutPdf.
    // Ele gera uma tela de pré-visualização e permite compartilhar/imprimir.
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // As funções abaixo continuam exatamente as mesmas de antes
  pw.Widget _construirCabecalho() {
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Relatório de Fiscalização - Orquestra Contratos',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
        ),
        pw.SizedBox(height: 5),
        pw.Text('Gerado em: $dataFormatada'),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _construirSecaoContrato(Map<String, dynamic> contrato) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          contrato['numero'] ?? 'Número não informado',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Objeto: ${contrato['objeto'] ?? 'Não informado'}'),
        pw.Text('Status: ${contrato['status'] ?? 'Não informado'}'),
      ],
    );
  }

  pw.Widget _construirListaOcorrencias(List<dynamic>? ocorrencias) {
    if (ocorrencias == null || ocorrencias.isEmpty) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(left: 15, top: 10),
        child: pw.Text('Nenhuma ocorrência registrada.', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 15),
          child: pw.Text('Ocorrências:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 5),
        for (final ocorrencia in ocorrencias)
          pw.Container(
            padding: const pw.EdgeInsets.only(left: 30, bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('- Título: ${ocorrencia['titulo'] ?? ''} (${ocorrencia['data'] ?? ''})'),
                pw.Text('  Descrição: ${ocorrencia['descricao'] ?? ''}'),
              ],
            ),
          ),
      ],
    );
  }
}