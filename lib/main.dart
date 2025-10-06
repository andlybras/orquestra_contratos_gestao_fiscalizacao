// CÓDIGO COMPLETO PARA: lib/main.dart

import 'package:flutter/material.dart';
// Import do novo pacote
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:orquestra_contratos_gestao_fiscalizacao/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orquestra Contratos',
      debugShowCheckedModeBanner: false,
      
      // --- CONFIGURAÇÃO DE LOCALIZAÇÃO ADICIONADA ---
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Suporte para Português do Brasil
      ],
      locale: const Locale('pt', 'BR'), // Define o pt-BR como padrão

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}