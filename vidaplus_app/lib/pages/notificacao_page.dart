import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/notificacao.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  // Em vez de um Future, guardamos a lista de notificações no estado
  List<Notificacao> _notificacoes = [];
  bool _isLoading = true;
  String? _errorMessage;

  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchNotificacoes();
  }

  Future<void> _fetchNotificacoes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final notificacoes = await _apiService.getMinhasNotificacoes();
      if (mounted) {
        setState(() {
          _notificacoes = notificacoes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _marcarComoLida(Notificacao notificacao) async {
    // Se a notificação já foi lida, não fazemos nada
    if (notificacao.lida) return;

    try {
      // Chama a API para marcar como lida no backend
      await _apiService.marcarNotificacaoComoLida(notificacao.id);

      // Atualiza o estado localmente para uma resposta visual imediata
      setState(() {
        notificacao.lida = true;
      });
    } catch (e) {
      // Se der erro, mostra uma mensagem
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao marcar como lida: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Notificações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchNotificacoes,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text('Erro ao carregar notificações: $_errorMessage'));
    }
    if (_notificacoes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhuma notificação por aqui.', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _notificacoes.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notificacao = _notificacoes[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: notificacao.lida ? Colors.grey.shade300 : Theme.of(context).primaryColor,
            foregroundColor: notificacao.lida ? Colors.grey.shade600 : Colors.white,
            child: const Icon(Icons.notifications),
          ),
          title: Text(
            notificacao.mensagem,
            style: TextStyle(
              fontWeight: notificacao.lida ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Text(
            DateFormat("d/MM/y 'às' HH:mm").format(notificacao.dataCriacao),
          ),
          onTap: () => _marcarComoLida(notificacao),
        );
      },
    );
  }
}