import 'package:flutter/material.dart';
import 'package:vidaplus_app/models/consulta.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class AnotacoesConsultaPage extends StatefulWidget {
  final Consulta consulta;
  const AnotacoesConsultaPage({super.key, required this.consulta});

  @override
  State<AnotacoesConsultaPage> createState() => _AnotacoesConsultaPageState();
}

class _AnotacoesConsultaPageState extends State<AnotacoesConsultaPage> {
  late final TextEditingController _anotacoesController;
  final _apiService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _anotacoesController = TextEditingController(text: widget.consulta.anotacoesClinicas);
  }

  @override
  void dispose() {
    _anotacoesController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    setState(() => _isLoading = true);
    try {
      await _apiService.salvarAnotacoes(widget.consulta.id, _anotacoesController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anotações salvas com sucesso!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anotações Clínicas'),
        actions: [
          IconButton(
            icon: _isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white)) : const Icon(Icons.save),
            onPressed: _isLoading ? null : _salvar,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _anotacoesController,
          maxLines: null, // Permite que o campo cresça infinitamente
          expands: true, // Faz o campo ocupar todo o espaço vertical
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'Digite suas anotações sobre a consulta aqui...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}