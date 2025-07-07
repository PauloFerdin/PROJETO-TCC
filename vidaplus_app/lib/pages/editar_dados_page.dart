import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vidaplus_app/models/paciente.dart';
import 'package:vidaplus_app/services/auth_manager.dart';
import 'package:vidaplus_app/services/auth_service.dart';

import '../services/auth_manager.dart';

class EditarDadosPage extends StatefulWidget {
  const EditarDadosPage({super.key});

  @override
  State<EditarDadosPage> createState() => _EditarDadosPageState();
}

class _EditarDadosPageState extends State<EditarDadosPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = AuthService();
  late final TextEditingController _cpfController;
  late final TextEditingController _telefoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final paciente = AuthManager.instance.usuario?.paciente;
    _cpfController = TextEditingController(text: paciente?.cpf);
    _telefoneController = TextEditingController(text: paciente?.telefone);
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _salvarDados() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authManager = AuthManager.instance;
      final pacienteId = authManager.usuario?.paciente?.id;
      final token = authManager.token;

      if (pacienteId == null || token == null) {
        throw Exception('Usuário não autenticado corretamente.');
      }

      final dadosParaAtualizar = {
        'cpf': _cpfController.text,
        'telefone': _telefoneController.text,
      };

      final pacienteAtualizado = await _apiService.atualizarDadosPaciente(
        pacienteId,
        token,
        dadosParaAtualizar,
      );

      authManager.updatePacienteInfo(pacienteAtualizado);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: ${e.toString()}')),
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
    final usuario = AuthManager.instance.usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Meus Dados'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${usuario?.nome ?? ''}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Email: ${usuario?.email ?? ''}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarDados,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Salvar Alterações'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}