import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/consulta.dart';

class DetalhesConsultaPassadaPage extends StatelessWidget {
  final Consulta consulta;

  const DetalhesConsultaPassadaPage({super.key, required this.consulta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Consulta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.medical_services_outlined, 'Especialidade', consulta.nomeEspecialidade),
                    const Divider(height: 24),
                    _buildInfoRow(Icons.person_outline, 'Profissional', 'Dr(a). ${consulta.nomeProfissional}'),
                    const Divider(height: 24),
                    _buildInfoRow(Icons.calendar_today_outlined, 'Data',
                        consulta.dataConsulta != null
                            ? DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(consulta.dataConsulta!)
                            : 'Não informada'
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(Icons.access_time_outlined, 'Horário', consulta.horaConsulta),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Anotações do Profissional',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  consulta.anotacoesClinicas ?? 'Nenhuma anotação foi feita para esta consulta.',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}