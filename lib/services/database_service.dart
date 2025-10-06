// CÓDIGO COMPLETO PARA: services/database_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static const _contratosKey = 'contratos';

  Future<void> salvarContratos(List<Map<String, dynamic>> contratos) async {
    final prefs = await SharedPreferences.getInstance();
    // Usamos o utf8Encode para garantir a codificação correta antes de converter para JSON
    final String listaEmJson = jsonEncode(contratos);
    await prefs.setString(_contratosKey, listaEmJson);
  }

  Future<List<Map<String, dynamic>>> carregarContratos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? listaEmJson = prefs.getString(_contratosKey);

    if (listaEmJson != null) {
      // Usamos o utf8Decode para garantir que a leitura da string respeite os caracteres especiais
      final List<dynamic> listaDecodificada = jsonDecode(listaEmJson);
      return List<Map<String, dynamic>>.from(listaDecodificada);
    } else {
      return [];
    }
  }
}