// 1. Importação: Inclui a 'caixa de ferramentas' de widgets visuais do Flutter (estilo Material Design).
import 'package:flutter/material.dart';

// 2. Ponto de Partida: A função `main` é a 'ignição' do nosso aplicativo. A execução sempre começa aqui.
void main() {
  // `runApp` é o comando que diz ao Flutter para desenhar nosso app na tela.
  runApp(const MyApp());
}

// 3. O Widget Principal: Esta é a 'planta baixa' do nosso aplicativo.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // O método `build` descreve como o aplicativo deve ser desenhado.
  @override
  Widget build(BuildContext context) {
    // 4. A Fundação: MaterialApp é o widget base que configura o tema, título e navegação.
    return MaterialApp(
      // Título usado pelo sistema operacional (ex: na lista de apps recentes).
      title: 'Orquestra Contratos',
      debugShowCheckedModeBanner: false, // Remove a faixa "DEBUG" do canto da tela.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // 5. O Esqueleto da Tela: `Scaffold` nos dá a estrutura de uma página (barra de topo, corpo, etc).
      home: Scaffold(
        // `appBar` é a barra de título no topo.
        appBar: AppBar(
          // Título que aparece visivelmente na barra.
          title: const Text('Orquestra Contratos'),
        ),
        // `body` é o conteúdo principal da nossa tela.
        body: const Center(
          // `Center` centraliza o widget filho.
          child: Text(
            'Gestão e Fiscalização', // Nosso lema!
          ),
        ),
      ),
    );
  }
}