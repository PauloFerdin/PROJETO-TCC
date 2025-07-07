import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vidaplus_app/services/auth_manager.dart';

class PacientePerfilPage extends StatefulWidget {
  const PacientePerfilPage({super.key});

  @override
  State<PacientePerfilPage> createState() => _PacientePerfilPageState();
}

class _PacientePerfilPageState extends State<PacientePerfilPage> {
  // Função para fazer logout
  void _logout() {
    // Mostra um diálogo de confirmação para uma melhor experiência
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem a certeza de que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              // Chama o método de logout do nosso AuthManager
              AuthManager.instance.logout();
              // Navega para a tela de login, limpando o histórico de navegação
              // O GoRouter irá redirecionar para /login automaticamente
              // por causa da lógica no 'redirect'.
              context.go('/login');
            },
            child: const Text('Sim, Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Acessamos a instância única do AuthManager para obter os dados do utilizador
    final usuario = AuthManager.instance.usuario;
    final paciente = usuario?.paciente;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          // Adicionamos um botão de logout na AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: usuario == null || paciente == null
      // Se, por algum motivo, os dados não estiverem disponíveis, mostramos uma mensagem
          ? const Center(
        child: Text('Não foi possível carregar os dados do perfil.'),
      )
      // Caso contrário, construímos a tela com as informações
          : ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            child: Text(
              usuario.nome.isNotEmpty ? usuario.nome[0].toUpperCase() : 'P',
              style: const TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              usuario.nome,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: usuario.email,
          ),
          _buildInfoTile(
            icon: Icons.badge_outlined,
            title: 'CPF',
            subtitle: paciente.cpf,
          ),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            title: 'Telefone',
            subtitle: paciente.telefone,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para a tela de edição
          context.push('/editar_dados');
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  // Widget auxiliar para criar os itens da lista de forma padronizada
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(
        subtitle ?? 'Não informado',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
    );
  }
}