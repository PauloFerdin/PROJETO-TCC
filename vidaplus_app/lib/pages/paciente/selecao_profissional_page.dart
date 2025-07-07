import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vidaplus_app/models/especialidade.dart';
import 'package:vidaplus_app/models/profissional.dart';
import 'package:vidaplus_app/services/auth_manager.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class SelecaoProfissionalPage extends StatefulWidget {
  final Especialidade especialidade;

  const SelecaoProfissionalPage({super.key, required this.especialidade});

  @override
  State<SelecaoProfissionalPage> createState() => _SelecaoProfissionalPageState();
}

class _SelecaoProfissionalPageState extends State<SelecaoProfissionalPage> {
  late final Future<List<Profissional>> _profissionaisFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    final token = AuthManager.instance.token;
    if (token != null) {
      _profissionaisFuture = _apiService.getProfissionaisPorEspecialidade(widget.especialidade.id);
    } else {
      _profissionaisFuture = Future.error('Usuário não autenticado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.especialidade.nome),
      ),
      body: FutureBuilder<List<Profissional>>(
        future: _profissionaisFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar profissionais: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum profissional encontrado para esta especialidade.'));
          }

          final profissionais = snapshot.data!;
          return ListView.builder(
            itemCount: profissionais.length,
            itemBuilder: (context, index) {
              final profissional = profissionais[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(profissional.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(widget.especialidade.nome),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/selecao_data_hora', extra: profissional);
                    print('Selecionou o profissional: ${profissional.nome}');
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