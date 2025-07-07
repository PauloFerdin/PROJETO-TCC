import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/consulta.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class AgendaProfissionalPage extends StatefulWidget {
  const AgendaProfissionalPage({super.key});

  @override
  State<AgendaProfissionalPage> createState() => _AgendaProfissionalPageState();
}

class _AgendaProfissionalPageState extends State<AgendaProfissionalPage> {
  late Future<List<Consulta>> _proximasConsultasFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchConsultas();
  }

  void _fetchConsultas() {
    setState(() {
      _proximasConsultasFuture = _apiService.getProximasConsultasProfissional();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximas Consultas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchConsultas,
          ),
        ],
      ),
      body: FutureBuilder<List<Consulta>>(
        future: _proximasConsultasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar a agenda: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma consulta futura encontrada.'));
          }

          final consultas = snapshot.data!;
          return ListView.builder(
            itemCount: consultas.length,
            itemBuilder: (context, index) {
              final consulta = consultas[index];
              // Lógica para adicionar um cabeçalho de data
              bool showHeader = index == 0 ||
                  consultas[index - 1].dataConsulta!.day != consulta.dataConsulta!.day ||
                  consultas[index - 1].dataConsulta!.month != consulta.dataConsulta!.month ||
                  consultas[index - 1].dataConsulta!.year != consulta.dataConsulta!.year;

              if (showHeader) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(consulta.dataConsulta!),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildConsultaCard(consulta),
                  ],
                );
              }
              return _buildConsultaCard(consulta);
            },
          );
        },
      ),
    );
  }

  // Widget para o card da consulta
  Widget _buildConsultaCard(Consulta consulta) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        // Substituímos o CircleAvatar por um Container
        leading: Container(
          width: 80, // Largura fixa para alinhar todos os itens
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5)),
          ),
          child: Center(
            child: Text(
              consulta.horaConsulta,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        title: Text(consulta.nomePaciente, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Status: ${consulta.status}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navega para a tela de detalhes da consulta que já criámos
          context.push('/detalhes_consulta_profissional', extra: consulta);
        },
      ),
    );
  }
}