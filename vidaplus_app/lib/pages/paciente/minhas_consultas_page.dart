import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/consulta.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class MinhasConsultasPage extends StatefulWidget {
  const MinhasConsultasPage({super.key});

  @override
  State<MinhasConsultasPage> createState() => _MinhasConsultasPageState();
}

class _MinhasConsultasPageState extends State<MinhasConsultasPage> {
  late Future<List<Consulta>> _consultasFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchConsultas();
  }

  // Criamos um método para poder chamar a API novamente e atualizar a tela
  void _fetchConsultas() {
    setState(() {
      _consultasFuture = _apiService.getMinhasConsultas();
    });
  }

  // Função para mostrar o diálogo de confirmação
  void _showCancelDialog(Consulta consulta) {
    // Só permite cancelar se a consulta estiver 'AGENDADA'
    if (consulta.status != 'AGENDADA') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Apenas consultas agendadas podem ser canceladas.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Cancelamento'),
          content: const Text('Tem a certeza de que deseja cancelar esta consulta?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Sim, Cancelar', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Fecha o diálogo
                _cancelarConsulta(consulta.id);
              },
            ),
          ],
        );
      },
    );
  }

  // Função que executa o cancelamento
  Future<void> _cancelarConsulta(String consultaId) async {
    try {
      await _apiService.cancelarConsulta(consultaId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consulta cancelada com sucesso!'), backgroundColor: Colors.green),
      );
      // Atualiza a lista para mostrar o novo status
      _fetchConsultas();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cancelar: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchConsultas,
          ),
        ],
      ),
      body: FutureBuilder<List<Consulta>>(
        future: _consultasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar agendamentos: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Você ainda não possui consultas agendadas.'));
          }

          final consultas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: consultas.length,
            itemBuilder: (context, index) {
              final consulta = consultas[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      consulta.dataConsulta != null
                          ? DateFormat('d').format(consulta.dataConsulta!)
                          : '?',
                    ),
                  ),
                  title: Text(
                    '${consulta.nomeEspecialidade} com Dr(a). ${consulta.nomeProfissional}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    consulta.dataConsulta != null
                        ? '${DateFormat("EEEE, d 'de' MMMM 'de' y", 'pt_BR').format(consulta.dataConsulta!)} às ${consulta.horaConsulta}'
                        : 'Data não informada',
                  ),
                  trailing: Chip(
                    label: Text(consulta.status, style: const TextStyle(fontSize: 12)),
                    backgroundColor: consulta.status == 'AGENDADA'
                        ? Colors.orange.shade100
                        : (consulta.status == 'CANCELADA' ? Colors.red.shade100 : Colors.grey.shade200),
                  ),
                  // Adicionamos a ação de toque aqui
                  onTap: () => _showCancelDialog(consulta),
                ),
              );
            },
          );
        },
      ),
    );
  }
}