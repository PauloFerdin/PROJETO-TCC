import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/consulta.dart';
import 'package:vidaplus_app/models/paciente.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class DetalhesPacientePage extends StatefulWidget {
  final Paciente paciente;
  const DetalhesPacientePage({super.key, required this.paciente});

  @override
  State<DetalhesPacientePage> createState() => _DetalhesPacientePageState();
}

class _DetalhesPacientePageState extends State<DetalhesPacientePage> {
  late Future<List<Consulta>> _historicoFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchHistorico();
  }

  void _fetchHistorico() {
    setState(() {
      _historicoFuture = _apiService.getConsultasDoPaciente(widget.paciente.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paciente.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add),
            tooltip: 'Solicitar Exame',
            onPressed: () {
              // Lógica para solicitar exame
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CPF: ${widget.paciente.cpf ?? 'Não informado'}', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text('Telefone: ${widget.paciente.telefone ?? 'Não informado'}', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Histórico de Consultas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _fetchHistorico(),
              child: FutureBuilder<List<Consulta>>(
                future: _historicoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar histórico: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Este paciente não possui histórico de consultas.'));
                  }

                  final consultas = snapshot.data!;
                  return ListView.builder(
                    itemCount: consultas.length,
                    itemBuilder: (context, index) {
                      final consulta = consultas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: ListTile(
                          title: Text(
                            'Consulta com Dr(a). ${consulta.nomeProfissional}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            consulta.dataConsulta != null
                                ? DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(consulta.dataConsulta!)
                                : "Data não informada",
                          ),
                          trailing: Text(consulta.horaConsulta, style: Theme.of(context).textTheme.titleMedium),
                          onTap: () {
                            context.push('/anotacoes_consulta', extra: consulta);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}