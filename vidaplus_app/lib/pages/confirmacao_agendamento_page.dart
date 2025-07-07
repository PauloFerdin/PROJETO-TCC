import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/profissional.dart';
import 'package:vidaplus_app/services/auth_manager.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class ConfirmacaoAgendamentoPage extends StatefulWidget {
  final Map<String, dynamic> dados;

  const ConfirmacaoAgendamentoPage({super.key, required this.dados});

  @override
  State<ConfirmacaoAgendamentoPage> createState() => _ConfirmacaoAgendamentoPageState();
}

class _ConfirmacaoAgendamentoPageState extends State<ConfirmacaoAgendamentoPage> {
  bool _isLoading = false;
  final _apiService = AuthService();

  Profissional get profissional => widget.dados['profissional'];
  DateTime get data => widget.dados['data'];
  String get hora => widget.dados['hora'];

  Future<void> _confirmarAgendamento() async {
    setState(() => _isLoading = true);

    final authManager = AuthManager.instance;
    final pacienteId = authManager.usuario?.paciente?.id;
    final token = authManager.token;

    if (pacienteId == null || token == null) {
      return;
    }

    try {
      await _apiService.agendarConsulta(
        pacienteId: pacienteId,
        profissionalId: profissional.id,
        data: DateFormat('yyyy-MM-dd').format(data),
        hora: hora,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consulta agendada com sucesso!'), backgroundColor: Colors.green),
        );
        context.go('/home_paciente');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao confirmar: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirme seu Agendamento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Resumo da Consulta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const Divider(height: 32),
                Text('Profissional:', style: TextStyle(color: Colors.grey.shade600)),
                Text('Dr(a). ${profissional.nome}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Text('Especialidade:', style: TextStyle(color: Colors.grey.shade600)),
                Text(profissional.especialidade ?? 'Não informada', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Text('Data:', style: TextStyle(color: Colors.grey.shade600)),
                Text(DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(data), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Text('Horário:', style: TextStyle(color: Colors.grey.shade600)),
                Text(hora, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _confirmarAgendamento,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirmar Agendamento'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}