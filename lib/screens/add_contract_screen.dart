// GARANTA QUE ESTA LINHA ESTEJA AQUI!
import 'package:flutter/material.dart';

// 1. Convertemos para StatefulWidget
class AddContractScreen extends StatefulWidget {
  const AddContractScreen({super.key});

  @override
  State<AddContractScreen> createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  // 2. Chave para identificar e controlar nosso formulário
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo Contrato'),
      ),
      // 3. Adicionamos um padding para o formulário não ficar colado nas bordas
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // 4. O widget Form, que agrupa e gerencia os campos de texto
        child: Form(
          key: _formKey, // Associamos a chave ao formulário
          child: Column(
            // `Column` organiza os widgets filhos em uma coluna vertical
            children: [
              // 5. O campo de texto para o número do contrato
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Número do Contrato',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16), // Apenas um espaço entre os campos
              // Campo de texto para o objeto do contrato
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Objeto do Contrato',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Campo de texto para a empresa contratada
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Empresa Contratada',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32), // Um espaço maior antes do botão
              // 6. Um botão para salvar o formulário
              ElevatedButton(
                onPressed: () {
                  // Ação de salvar (no futuro)
                },
                child: const Text('Salvar Contrato'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}