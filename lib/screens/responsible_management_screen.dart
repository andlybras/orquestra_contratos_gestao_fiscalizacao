// CÓDIGO COMPLETO PARA: screens/responsible_management_screen.dart

import 'package:flutter/material.dart';

class ResponsibleManagementScreen extends StatefulWidget {
  final List<Map<String, dynamic>> responsaveisIniciais;
  final String titulo;

  const ResponsibleManagementScreen({
    super.key,
    required this.responsaveisIniciais,
    required this.titulo,
  });

  @override
  State<ResponsibleManagementScreen> createState() => _ResponsibleManagementScreenState();
}

class _ResponsibleManagementScreenState extends State<ResponsibleManagementScreen> {
  late List<Map<String, dynamic>> _responsaveis;

  @override
  void initState() {
    super.initState();
    // Cria uma cópia da lista inicial para que possamos modificá-la
    _responsaveis = List<Map<String, dynamic>>.from(widget.responsaveisIniciais.map((e) => Map<String, dynamic>.from(e)));
  }

  // Função para mostrar o formulário de adicionar/editar
  void _mostrarFormularioResponsavel({Map<String, dynamic>? responsavel, int? index}) {
    final formKey = GlobalKey<FormState>();
    final nomeController = TextEditingController(text: responsavel?['nome']);
    final cpfController = TextEditingController(text: responsavel?['cpf']);
    final portariaController = TextEditingController(text: responsavel?['portaria']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(responsavel == null ? 'Adicionar ${widget.titulo.substring(10)}' : 'Editar ${widget.titulo.substring(10)}'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
                  TextFormField(controller: cpfController, decoration: const InputDecoration(labelText: 'CPF')),
                  TextFormField(controller: portariaController, decoration: const InputDecoration(labelText: 'Portaria')),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final novoResponsavel = {
                    'nome': nomeController.text,
                    'cpf': cpfController.text,
                    'portaria': portariaController.text,
                  };
                  setState(() {
                    if (index != null) {
                      _responsaveis[index] = novoResponsavel;
                    } else {
                      _responsaveis.add(novoResponsavel);
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        // Ao voltar, devolvemos a lista atualizada
        leading: BackButton(
          onPressed: () => Navigator.pop(context, _responsaveis),
        ),
      ),
      body: ListView.builder(
        itemCount: _responsaveis.length,
        itemBuilder: (context, index) {
          final responsavel = _responsaveis[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(responsavel['nome'] ?? ''),
              subtitle: Text('CPF: ${responsavel['cpf'] ?? ''} | Portaria: ${responsavel['portaria'] ?? ''}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => _responsaveis.removeAt(index)),
              ),
              onTap: () => _mostrarFormularioResponsavel(responsavel: responsavel, index: index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioResponsavel,
        child: const Icon(Icons.add),
      ),
    );
  }
}