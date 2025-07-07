import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vidaplus_app/models/especialidade.dart';
import 'package:vidaplus_app/models/register_request.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _registroController = TextEditingController();

  final _apiService = AuthService();
  bool _loading = false;
  UserRole? _perfilSelecionado;

  late Future<List<Especialidade>> _especialidadesFuture;
  Especialidade? _especialidadeSelecionada;

  @override
  void initState() {
    super.initState();
    // A chamada agora funcionará, pois o endpoint é público
    _especialidadesFuture = _apiService.getEspecialidades();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_perfilSelecionado == UserRole.PROFISSIONAL && _especialidadeSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma especialidade.')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final request = RegisterRequest(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        perfil: _perfilSelecionado!,
        especialidadeId: _perfilSelecionado == UserRole.PROFISSIONAL ? _especialidadeSelecionada!.id : null,
        registro: _perfilSelecionado == UserRole.PROFISSIONAL ? _registroController.text : null,
      );

      await _apiService.register(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário registrado com sucesso! Faça o login.'), backgroundColor: Colors.green),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crie sua Conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nomeController, decoration: const InputDecoration(labelText: 'Nome Completo')),
              const SizedBox(height: 16),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'E-mail')),
              const SizedBox(height: 16),
              TextFormField(controller: _senhaController, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
              const SizedBox(height: 16),
              DropdownButtonFormField<UserRole>(
                value: _perfilSelecionado,
                decoration: const InputDecoration(labelText: 'Eu sou um...'),
                items: UserRole.values
                    .where((role) => role == UserRole.PACIENTE || role == UserRole.PROFISSIONAL)
                    .map((role) {
                  String text;
                  switch (role) {
                    case UserRole.PACIENTE:
                      text = 'Paciente';
                      break;
                    case UserRole.PROFISSIONAL:
                      text = 'Profissional da Saúde';
                      break;
                    default:
                      text = '';
                  }
                  return DropdownMenuItem(value: role, child: Text(text));
                }).toList(),
                onChanged: (value) => setState(() => _perfilSelecionado = value),
                validator: (value) => value == null ? 'Selecione um perfil' : null,
              ),

              if (_perfilSelecionado == UserRole.PROFISSIONAL)
                _buildCamposProfissional(),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _registrar,
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Registrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCamposProfissional() {
    return Column(
      children: [
        const SizedBox(height: 16),
        FutureBuilder<List<Especialidade>>(
          future: _especialidadesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Não foi possível carregar as especialidades.', style: TextStyle(color: Colors.red));
            }
            return DropdownButtonFormField<Especialidade>(
              value: _especialidadeSelecionada,
              decoration: const InputDecoration(labelText: 'Especialidade'),
              items: snapshot.data!.map((especialidade) {
                return DropdownMenuItem(value: especialidade, child: Text(especialidade.nome));
              }).toList(),
              onChanged: (value) => setState(() => _especialidadeSelecionada = value),
              validator: (value) => value == null ? 'Selecione uma especialidade' : null,
            );
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _registroController,
          decoration: const InputDecoration(labelText: 'Nº de Registro (CRM, CRP, etc.)'),
          validator: (value) => (value == null || value.isEmpty) ? 'Informe seu registro' : null,
        ),
      ],
    );
  }
}