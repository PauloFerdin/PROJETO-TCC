import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/consulta.dart';

import '../../services/auth_service.dart';

class DetalhesConsultaPage extends StatelessWidget {
  final Consulta consulta;

  const DetalhesConsultaPage({super.key, required this.consulta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Consulta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildAcoesCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              Icons.person_outline,
              'Paciente',
              consulta.nomePaciente,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.medical_services_outlined,
              'Especialidade',
              consulta.nomeEspecialidade,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              'Data',
              consulta.dataConsulta != null
                  ? DateFormat(
                    "EEEE, d 'de' MMMM 'de' y",
                    'pt_BR',
                  ).format(consulta.dataConsulta!)
                  : 'Não informado',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.access_time_outlined,
              'Horário',
              consulta.horaConsulta,
            ),
            const Divider(height: 24),
            _buildInfoRow(Icons.info_outline, 'Status', consulta.status),
          ],
        ),
      ),
    );
  }

  Widget _buildAcoesCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.video_call_outlined),
              label: const Text('Iniciar Teleconsulta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                context.push('/teleconsulta_profissional');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.note_add_outlined),
              label: const Text('Adicionar Anotações'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                context.push('/anotacoes_consulta', extra: consulta);
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Cancelar Consulta'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Confirmar Cancelamento'),
                      content: const Text(
                        'Tem a certeza de que deseja cancelar esta consulta? Esta ação não pode ser desfeita.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Não'),
                          onPressed: () {
                            Navigator.of(
                              dialogContext,
                            ).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Sim, Cancelar',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            Navigator.of(
                              dialogContext,
                            ).pop();

                            try {
                              final authService = AuthService();
                              await authService.cancelarConsulta(consulta.id);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Consulta cancelada com sucesso.',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              if (context.canPop()) {
                                context.pop();
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
