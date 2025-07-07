import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vidaplus_app/models/paciente.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class PacientesProfissionalPage extends StatefulWidget {
  const PacientesProfissionalPage({super.key});

  @override
  State<PacientesProfissionalPage> createState() => _PacientesProfissionalPageState();
}

class _PacientesProfissionalPageState extends State<PacientesProfissionalPage> {
  late final Future<List<Paciente>> _pacientesFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _pacientesFuture = _apiService.getMeusPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pacientes'),
      ),
      body: FutureBuilder<List<Paciente>>(
        future: _pacientesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Erro ao carregar pacientes: ${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Nenhum paciente encontrado na sua lista.', textAlign: TextAlign.center),
              ),
            );
          }

          final pacientes = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: pacientes.length,
            separatorBuilder: (context, index) => const Divider(indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final paciente = pacientes[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(paciente.nome.isNotEmpty ? paciente.nome[0].toUpperCase() : '?'),
                ),
                title: Text(paciente.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('CPF: ${paciente.cpf ?? 'Não informado'}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/detalhes_paciente', extra: paciente);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selecionou o paciente: ${paciente.nome}')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}