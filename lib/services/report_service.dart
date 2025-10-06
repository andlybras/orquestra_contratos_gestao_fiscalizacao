// CÓDIGO COMPLETO E CORRIGIDO PARA: services/report_service.dart

import 'dart:io';
import 'package:archive/archive_io.dart';
// IMPORT ADICIONADO AQUI:
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ReportService {

  Future<void> gerarRelatorioParaContratoUnico(Map<String, dynamic> contrato) async {
    await gerarRelatorioPDF([contrato]);
  }

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
          final String? videoPath = ocorrencia['video_path'];
          final String? audioPath = ocorrencia['audio_path'];

          if (fotoPath != null) await _adicionarArquivoAoZip(encoder, fotoPath, 'Evidencias_Fotos');
          if (videoPath != null) await _adicionarArquivoAoZip(encoder, videoPath, 'Evidencias_Videos');
          if (audioPath != null) await _adicionarArquivoAoZip(encoder, audioPath, 'Evidencias_Audios');
        }
      }
    }
    
    encoder.close();

    final xFile = XFile(zipPath);
    await Share.shareXFiles([xFile], text: 'Dossiê de Contratos Gerado');
  }
  
  Future<void> _adicionarArquivoAoZip(ZipFileEncoder encoder, String path, String dir) async {
    final file = File(path);
    if (await file.exists()) {
      final fileName = path.split('/').last;
      encoder.addFile(file, '$dir/$fileName');
    }
  }
  
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
                  _buildQrCodeRow('Evidência fotográfica', ocorrencia['foto_path']),
                if (ocorrencia['video_path'] != null)
                  _buildQrCodeRow('Evidência em vídeo', ocorrencia['video_path']),
                if (ocorrencia['audio_path'] != null)
                  _buildQrCodeRow('Evidência em áudio', ocorrencia['audio_path']),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _buildQrCodeRow(String label, String data) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8, left: 12),
      child: pw.Row(
        children: [
          pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: Uri.file(data).toString(),
            width: 40,
            height: 40,
          ),
          pw.SizedBox(width: 10),
          pw.Text('Anexo: $label'),
        ],
      ),
    );
  }
}