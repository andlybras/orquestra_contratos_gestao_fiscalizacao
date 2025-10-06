// CÓDIGO COMPLETO PARA: services/database_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static const _contratosKey = 'contratos';

  Future<void> salvarContratos(List<Map<String, dynamic>> contratos) async {
    final prefs = await SharedPreferences.getInstance();
    // A função jsonEncode já lida com a codificação UTF-8 por padrão.
    final String listaEmJson = jsonEncode(contratos);
    await prefs.setString(_contratosKey, listaEmJson);
  }

  Future<List<Map<String, dynamic>>> carregarContratos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? listaEmJson = prefs.getString(
      _contratosKey,
    ); // A string já vem em UTF-8.

    if (listaEmJson != null) {
      // A função jsonDecode espera uma string em UTF-8, que é o que o SharedPreferences retorna.
      final List<dynamic> listaDecodificada = jsonDecode(listaEmJson);
      return List<Map<String, dynamic>>.from(listaDecodificada);
    } else {
      return [];
    }
  }
}
