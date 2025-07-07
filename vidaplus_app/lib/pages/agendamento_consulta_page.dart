import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vidaplus_app/models/especialidade.dart';
import 'package:vidaplus_app/services/auth_manager.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class AgendamentoConsultaPage extends StatefulWidget {
  const AgendamentoConsultaPage({super.key});

  @override
  State<AgendamentoConsultaPage> createState() => _AgendamentoConsultaPageState();
}

class _AgendamentoConsultaPageState extends State<AgendamentoConsultaPage> {
  late final Future<List<Especialidade>> _especialidadesFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _especialidadesFuture = _apiService.getEspecialidades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Nova Consulta'),

      ),
      body: FutureBuilder<List<Especialidade>>(
        future: _especialidadesFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar especialidades: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma especialidade encontrada.'));
          }

          final especialidades = snapshot.data!;
          return ListView.builder(
            itemCount: especialidades.length,
            itemBuilder: (context, index) {
              final especialidade = especialidades[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.medical_services_outlined, color: Colors.blueAccent),
                  title: Text(especialidade.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/selecao_profissional', extra: especialidade);
                    print('Selecionou: ${especialidade.nome} (ID: ${especialidade.id})');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selecionou: ${especialidade.nome}')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}