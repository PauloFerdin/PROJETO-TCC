import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/consulta.dart';
import 'package:vidaplus_app/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class PacienteConsultasPage extends StatefulWidget {
  const PacienteConsultasPage({super.key});

  @override
  State<PacienteConsultasPage> createState() => _PacienteConsultasPageState();
}

class _PacienteConsultasPageState extends State<PacienteConsultasPage> {
  late Future<List<Consulta>> _consultasFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchConsultas();
  }

  void _fetchConsultas() {
    setState(() {
      _consultasFuture = _apiService.getMinhasConsultas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Teremos 2 abas: Próximas e Histórico
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Consultas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchConsultas,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'PRÓXIMAS'),
              Tab(text: 'HISTÓRICO'),
            ],
          ),
        ),
        body: FutureBuilder<List<Consulta>>(
          future: _consultasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar consultas: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma consulta encontrada.'));
            }

            // Filtramos a lista de consultas em duas: próximas e anteriores
            final now = DateTime.now();
            final hoje = DateTime(now.year, now.month, now.day);

            final proximasConsultas = snapshot.data!
                .where((c) => c.dataConsulta != null &&
                (c.dataConsulta!.isAtSameMomentAs(hoje) || c.dataConsulta!.isAfter(hoje)) &&
                c.status == 'AGENDADA')
                .toList();

            final consultasAnteriores = snapshot.data!
                .where((c) => c.dataConsulta != null &&
                (c.dataConsulta!.isBefore(hoje) || c.status != 'AGENDADA'))
                .toList();

            return TabBarView(
              children: [
                // Aba 1: Próximas Consultas
                _buildConsultaList(
                  context,
                  proximasConsultas,
                  'Você não tem nenhuma consulta futura agendada.',
                ),
                // Aba 2: Histórico de Consultas
                _buildConsultaList(
                  context,
                  consultasAnteriores,
                  'Você ainda não possui um histórico de consultas.',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget reutilizável para construir as listas de consultas
  Widget _buildConsultaList(BuildContext context, List<Consulta> consultas, String emptyMessage) {
    if (consultas.isEmpty) {
      return Center(child: Text(emptyMessage, textAlign: TextAlign.center));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: consultas.length,
      itemBuilder: (context, index) {
        final consulta = consultas[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(consulta.status),
              foregroundColor: Colors.white,
              child: Text(
                consulta.dataConsulta != null ? DateFormat('d').format(consulta.dataConsulta!) : '?',
              ),
            ),
            title: Text(
              '${consulta.nomeEspecialidade} com Dr(a). ${consulta.nomeProfissional}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              consulta.dataConsulta != null
                  ? DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(consulta.dataConsulta!) + ' às ${consulta.horaConsulta}'
                  : 'Data não informada',
            ),
            onTap: () {
              // Ao tocar, leva para a tela de detalhes que já criámos
              context.push('/detalhes_consulta_paciente', extra: consulta);
            },
          ),
        );
      },
    );
  }

  // Função auxiliar para definir a cor do avatar com base no status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'AGENDADA':
        return Colors.blueAccent;
      case 'REALIZADA':
        return Colors.green;
      case 'CANCELADA':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}