import 'package:flutter/material.dart';

class AddContractScreen extends StatelessWidget {
  const AddContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo Contrato'),
      ),
      body: const Center(
        child: Text('Aqui ficará o formulário de cadastro.'),
      ),
    );
  }
}