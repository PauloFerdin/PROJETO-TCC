import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // <-- IMPORT CORRIGIDO AQUI
import 'package:vidaplus_app/models/consulta.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class HistoricoClinicoPage extends StatefulWidget {
  const HistoricoClinicoPage({super.key});

  @override
  State<HistoricoClinicoPage> createState() => _HistoricoClinicoPageState();
}

class _HistoricoClinicoPageState extends State<HistoricoClinicoPage> {
  late final Future<List<Consulta>> _consultasFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _consultasFuture = _apiService.getMinhasConsultas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Histórico Clínico'),
      ),
      body: FutureBuilder<List<Consulta>>(
        future: _consultasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar histórico: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Você não possui um histórico de consultas.'));
          }

          final now = DateTime.now();
          final consultasPassadas = snapshot.data!.where((consulta) {
            if (consulta.dataConsulta == null) return false;
            return consulta.dataConsulta!.isBefore(DateTime(now.year, now.month, now.day)) ||
                consulta.status == 'REALIZADA' ||
                consulta.status == 'CANCELADA';
          }).toList();

          if (consultasPassadas.isEmpty) {
            return const Center(child: Text('Nenhuma consulta passada encontrada no seu histórico.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: consultasPassadas.length,
            itemBuilder: (context, index) {
              final consulta = consultasPassadas[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: _getStatusIcon(consulta.status),
                  title: Text(
                    '${consulta.nomeEspecialidade} com Dr(a). ${consulta.nomeProfissional}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(consulta.dataConsulta!),
                  ),
                  onTap: () {
                    context.push('/detalhes_consulta_paciente', extra: consulta);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'REALIZADA':
        return const CircleAvatar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: Icon(Icons.check),
        );
      case 'CANCELADA':
        return const CircleAvatar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          child: Icon(Icons.close),
        );
      default:
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          child: Icon(Icons.history),
        );
    }
  }
}