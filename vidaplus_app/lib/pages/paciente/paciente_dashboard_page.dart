import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/consulta.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class PacienteDashboardPage extends StatefulWidget {
  const PacienteDashboardPage({super.key});

  @override
  State<PacienteDashboardPage> createState() => _PacienteDashboardPageState();
}

class _PacienteDashboardPageState extends State<PacienteDashboardPage> {
  late Future<Consulta?> _proximaConsultaFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _proximaConsultaFuture = _apiService.getProximaConsulta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo(a)!'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              context.push('/notificacoes');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // O card da próxima consulta agora é construído por um FutureBuilder
            FutureBuilder<Consulta?>(
              future: _proximaConsultaFuture,
              builder: (context, snapshot) {
                // Enquanto carrega
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Se deu erro
                if (snapshot.hasError) {
                  return _buildErroCard();
                }
                // Se carregou, mas não há consultas
                if (!snapshot.hasData || snapshot.data == null) {
                  return _buildNenhumaConsultaCard(context);
                }
                // SUCESSO! Mostra o card com os dados reais.
                return _buildProximaConsultaCard(context, snapshot.data!);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'O que você precisa?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAcoesGrid(context),
          ],
        ),
      ),
    );
  }

  // Card para quando uma consulta é encontrada
  Widget _buildProximaConsultaCard(BuildContext context, Consulta consulta) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sua Próxima Consulta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${consulta.nomeEspecialidade} com Dr(a). ${consulta.nomeProfissional}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat(
                    "d 'de' MMMM",
                    'pt_BR',
                  ).format(consulta.dataConsulta!),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(
                  consulta.horaConsulta,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Card para quando NÃO há próximas consultas
  Widget _buildNenhumaConsultaCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Você não tem próximas consultas.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/agendar_consulta'),
              child: const Text('Agendar uma agora'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErroCard() {
    return const Card(
      color: Colors.redAccent,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 16),
            Expanded(
              child: Text('Não foi possível carregar sua próxima consulta.'),
            ),
          ],
        ),
      ),
    );
  }

  // O seu grid de ações continua o mesmo
  Widget _buildAcoesGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildAcaoItem(
          context,
          icon: Icons.edit_calendar,
          label: 'Agendar Consulta',
          color: Colors.orange,
          onTap: () => context.push('/agendar_consulta'),
        ),
        _buildAcaoItem(
          context,
          icon: Icons.calendar_month_outlined,
          label: 'Meus Agendamentos',
          color: Colors.teal,
          onTap: () => context.push('/minhas_consultas'),
        ),
        _buildAcaoItem(
          context,
          icon: Icons.video_call,
          label: 'Aceder à Teleconsulta',
          color: Colors.green,
          onTap: () => context.push('/teleconsulta_paciente'),
        ),
        _buildAcaoItem(
          context,
          icon: Icons.history,
          label: 'Histórico Clínico',
          color: Colors.purple,
          onTap: () => context.push('/historico_clinico'),
        ),
        _buildAcaoItem(
          context,
          icon: Icons.person_search,
          label: 'Meus Dados',
          color: Colors.red,
          onTap: () => context.push('/dados_pessoais'),
        ),
        _buildAcaoItem(
          context,
          icon: Icons.biotech_outlined,
          label: 'Meus Exames',
          color: Colors.cyan,
          onTap: () {
            context.push('/meus_exames');
          },
        ),
      ],
    );
  }

  Widget _buildAcaoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
