// CÓDIGO COMPLETO PARA: services/report_service.dart

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import do novo pacote de QR Code

class ReportService {
  Future<void> gerarRelatorioParaContratoUnico(Map<String, dynamic> contrato) async {
    final List<Map<String, dynamic>> listaDeUmContrato = [contrato];
    await gerarRelatorioPDF(listaDeUmContrato);
  }

  Future<void> gerarRelatorioPDF(List<Map<String, dynamic>> contratos) async {
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

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _construirCabecalho() {
    // ... (esta função não muda)
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Relatório de Fiscalização - Orquestra Contratos',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
          pw.SizedBox(height: 5),
          pw.Text('Gerado em: $dataFormatada'),
          pw.SizedBox(height: 20),
        ]);
  }

  pw.Widget _construirSecaoContrato(Map<String, dynamic> contrato) {
    // ... (esta função não muda)
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(contrato['numero'] ?? 'Número não informado',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
          pw.SizedBox(height: 8),
          pw.Text('Objeto: ${contrato['objeto'] ?? 'Não informado'}'),
          pw.Text('Status: ${contrato['status'] ?? 'Não informado'}'),
        ]);
  }

  // A MUDANÇA PRINCIPAL ESTÁ AQUI
  pw.Widget _construirListaOcorrencias(List<dynamic>? ocorrencias) {
    if (ocorrencias == null || ocorrencias.isEmpty) {
      return pw.Padding(
          padding: const pw.EdgeInsets.only(left: 15, top: 10),
          child: pw.Text('Nenhuma ocorrência registrada.',
              style: pw.TextStyle(fontStyle: pw.FontStyle.italic)));
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
            padding: const pw.EdgeInsets.only(left: 30, bottom: 15),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('- Título: ${ocorrencia['titulo'] ?? ''} (${ocorrencia['data'] ?? ''})'),
                pw.Text('  Descrição: ${ocorrencia['descricao'] ?? ''}'),
                // Lógica para adicionar o QR Code se a foto existir
                if (ocorrencia['foto_path'] != null)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 8, left: 12),
                    child: pw.Row(
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: Uri.file(ocorrencia['foto_path']).toString(),
                          width: 40,
                          height: 40,
                        ),
                        pw.SizedBox(width: 10),
                        pw.Text('Anexo: Evidência fotográfica'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}