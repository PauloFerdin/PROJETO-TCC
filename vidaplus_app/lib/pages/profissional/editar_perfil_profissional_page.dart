import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vidaplus_app/services/auth_manager.dart';
import '../../services/auth_service.dart';

class EditarPerfilProfissionalPage extends StatefulWidget {
  const EditarPerfilProfissionalPage({super.key});

  @override
  State<EditarPerfilProfissionalPage> createState() => _EditarPerfilProfissionalPageState();
}

class _EditarPerfilProfissionalPageState extends State<EditarPerfilProfissionalPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = AuthService();
  late final TextEditingController _registroController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profissional = AuthManager.instance.usuario?.profissional;
    _registroController = TextEditingController(text: profissional?.registro);
  }

  @override
  void dispose() {
    _registroController.dispose();
    super.dispose();
  }

  Future<void> _salvarPerfil() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final profissionalAtualizado = await _apiService.atualizarPerfilProfissional(
        registro: _registroController.text,
      );

      AuthManager.instance.updateProfissionalInfo(profissionalAtualizado);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!'), backgroundColor: Colors.green),
        );
        context.pop();
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
        title: const Text('Editar Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _registroController,
                decoration: const InputDecoration(
                  labelText: 'Nº de Registo (CRM, CRP, etc.)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o seu número de registo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarPerfil,
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