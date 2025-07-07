import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/exame.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class MeusExamesPage extends StatefulWidget {
  const MeusExamesPage({super.key});

  @override
  State<MeusExamesPage> createState() => _MeusExamesPageState();
}

class _MeusExamesPageState extends State<MeusExamesPage> {
  late final Future<List<Exame>> _examesFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _examesFuture = _apiService.getMeusExames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Exames'),
      ),
      body: FutureBuilder<List<Exame>>(
        future: _examesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar exames: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Nenhum exame solicitado encontrado.', textAlign: TextAlign.center),
              ),
            );
          }

          final exames = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: exames.length,
            itemBuilder: (context, index) {
              final exame = exames[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.description_outlined, color: Colors.indigo),
                  title: Text(exame.nomeExame, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Solicitado por Dr(a). ${exame.nomeProfissionalSolicitante} em ${DateFormat('d/MM/y').format(exame.dataSolicitacao)}'
                  ),
                  onTap: () {
                     context.push('/detalhes_exame', extra: exame);
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