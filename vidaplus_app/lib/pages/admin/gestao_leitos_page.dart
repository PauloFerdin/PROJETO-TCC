import 'package:flutter/material.dart';
import 'package:vidaplus_app/models/leito.dart';
import 'package:vidaplus_app/models/status_leito.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class GestaoLeitosPage extends StatefulWidget {
  const GestaoLeitosPage({super.key});

  @override
  State<GestaoLeitosPage> createState() => _GestaoLeitosPageState();
}

class _GestaoLeitosPageState extends State<GestaoLeitosPage> {
  late Future<List<Leito>> _leitosFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchLeitos();
  }

  void _fetchLeitos() {
    setState(() {
      _leitosFuture = _apiService.getLeitos();
    });
  }

  Color _getStatusColor(StatusLeito status) {
    switch (status) {
      case StatusLeito.LIVRE: return Colors.green.shade100;
      case StatusLeito.OCUPADO: return Colors.red.shade100;
      case StatusLeito.EM_LIMPEZA: return Colors.blue.shade100;
      case StatusLeito.EM_MANUTENCAO: return Colors.orange.shade100;
    }
  }

  IconData _getStatusIcon(StatusLeito status) {
    switch (status) {
      case StatusLeito.LIVRE: return Icons.check_circle_outline;
      case StatusLeito.OCUPADO: return Icons.person_outline;
      case StatusLeito.EM_LIMPEZA: return Icons.cleaning_services_outlined;
      case StatusLeito.EM_MANUTENCAO: return Icons.build_outlined;
    }
  }

  void _showUpdateStatusDialog(Leito leito) {
    showDialog(
      context: context,
      builder: (context) {
        StatusLeito? statusSelecionado = leito.status;
        return AlertDialog(
          title: Text('Alterar Status do Leito ${leito.numeroDoLeito}'),
          content: DropdownButton<StatusLeito>(
            value: statusSelecionado,
            isExpanded: true,
            items: StatusLeito.values.map((StatusLeito status) {
              return DropdownMenuItem<StatusLeito>(
                value: status,
                child: Text(status.name),
              );
            }).toList(),
            onChanged: (novoStatus) {
              if (novoStatus != null) {
                statusSelecionado = novoStatus;
              }
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (statusSelecionado != null) {
                  Navigator.of(context).pop();
                  await _atualizarStatus(leito, statusSelecionado!);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _atualizarStatus(Leito leito, StatusLeito novoStatus) async {
    try {
      await _apiService.atualizarStatusLeito(leito.id, novoStatus);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status atualizado!'), backgroundColor: Colors.green));
      _fetchLeitos(); // Atualiza a lista
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Leitos'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchLeitos)],
      ),
      body: FutureBuilder<List<Leito>>(
        future: _leitosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar leitos: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum leito encontrado.'));
          }

          final leitos = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: leitos.length,
            itemBuilder: (context, index) {
              final leito = leitos[index];
              return InkWell(
                onTap: () => _showUpdateStatusDialog(leito),
                child: Card(
                  color: _getStatusColor(leito.status),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_getStatusIcon(leito.status), size: 40),
                      const SizedBox(height: 8),
                      Text('Leito ${leito.numeroDoLeito}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(leito.setor),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}