import 'package:flutter/material.dart';

// Importa o nosso novo arquivo de tela, criando a ponte entre os dois.
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orquestra Contratos',
      debugShowCheckedModeBanner: false, // Remove a faixa "DEBUG"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // Agora, a nossa tela inicial é o widget HomeScreen que acabamos de criar!
      home: const HomeScreen(),
    );
  }
}