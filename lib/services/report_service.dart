import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart'; // Import do novo pacote de compartilhamento

class ReportService {

  Future<void> gerarRelatorioParaContratoUnico(Map<String, dynamic> contrato) async {
    await gerarRelatorioPDF([contrato]);
  }

  // NOVO: Método para gerar o Dossiê de um único contrato
  Future<void> gerarDossieParaContratoUnico(Map<String, dynamic> contrato) async {
    await gerarDossieCompleto([contrato]);
  }

  Future<void> gerarRelatorioPDF(List<Map<String, dynamic>> contratos) async {
    final pdf = await _criarDocumentoPDF(contratos);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> gerarDossieCompleto(List<Map<String, dynamic>> contratos) async {
    final pdf = await _criarDocumentoPDF(contratos);
    final pdfBytes = await pdf.save();

    final directory = await getTemporaryDirectory();
    final zipPath = '${directory.path}/dossie_contratos.zip';
    final encoder = ZipFileEncoder();
    encoder.create(zipPath);
    encoder.addArchiveFile(ArchiveFile('Relatorio_Contratos.pdf', pdfBytes.length, pdfBytes));

    for (final contrato in contratos) {
      final List<dynamic>? ocorrencias = contrato['ocorrencias'];
      if (ocorrencias != null) {
        for (final ocorrencia in ocorrencias) {
          final String? fotoPath = ocorrencia['foto_path'];
          if (fotoPath != null) {
            final file = File(fotoPath);
            if (await file.exists()) {
              final fileName = fotoPath.split('/').last;
              encoder.addFile(file, 'Evidencias/$fileName');
            }
          }
        }
      }
    }
    
    encoder.close();

    // A MUDANÇA ESTÁ AQUI: Usamos o Share.shareXFiles para compartilhar o ZIP
    final xFile = XFile(zipPath);
    await Share.shareXFiles([xFile], text: 'Dossiê de Contratos Gerado');
  }

  // --- MÉTODOS PRIVADOS DE CONSTRUÇÃO DO PDF ---

  // Refatoramos a criação do PDF para este método, para ser reutilizado
  Future<pw.Document> _criarDocumentoPDF(List<Map<String, dynamic>> contratos) async {
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
    return pdf;
  }

  pw.Widget _construirCabecalho() {
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Relatório de Fiscalização - Orquestra Contratos', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
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
        pw.Text(contrato['numero'] ?? 'Número não informado', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
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
            padding: const pw.EdgeInsets.only(left: 30, bottom: 15),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('- Título: ${ocorrencia['titulo'] ?? ''} (${ocorrencia['data'] ?? ''})'),
                pw.Text('  Descrição: ${ocorrencia['descricao'] ?? ''}'),
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