import 'dart:convert'; // Pacote para converter dados para JSON
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  // Chave para salvar nossos dados no "cofre"
  static const _contratosKey = 'contratos';

  // Método para SALVAR a lista de contratos
  Future<void> salvarContratos(List<Map<String, dynamic>> contratos) async {
    final prefs = await SharedPreferences.getInstance();
    // Convertemos a lista de Mapas para uma String no formato JSON
    final String listaEmJson = jsonEncode(contratos);
    // Salvamos a string no cofre
    await prefs.setString(_contratosKey, listaEmJson);
  }

  // Método para CARREGAR a lista de contratos
  Future<List<Map<String, dynamic>>> carregarContratos() async {
    final prefs = await SharedPreferences.getInstance();
    // Buscamos a string JSON do cofre
    final String? listaEmJson = prefs.getString(_contratosKey);

    if (listaEmJson != null) {
      // Se encontramos dados, convertemos a string JSON de volta para uma lista de Mapas
      final List<dynamic> listaDecodificada = jsonDecode(listaEmJson);
      return List<Map<String, dynamic>>.from(listaDecodificada);
    } else {
      // Se não houver nada salvo, retornamos uma lista vazia
      return [];
    }
  }
}