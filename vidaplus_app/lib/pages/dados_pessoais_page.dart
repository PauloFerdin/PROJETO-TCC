import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vidaplus_app/services/auth_manager.dart';

class DadosPessoaisPage extends StatelessWidget {
  const DadosPessoaisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authManager = AuthManager.instance;
    final paciente = authManager.usuario?.paciente;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
      ),
      body: paciente == null
          ? const Center(
        child: Text('Dados do paciente não encontrados.'),
      )
          : ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const SizedBox(height: 16),
          _buildInfoTile(
            icon: Icons.person_outline,
            title: 'Nome Completo',
            subtitle: paciente.nome,
          ),
          const Divider(),
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: 'E-mail de Contato',
            subtitle: authManager.usuario?.email,
          ),
          const Divider(),
          _buildInfoTile(
            icon: Icons.badge_outlined,
            title: 'CPF',
            subtitle: paciente.cpf,
          ),
          const Divider(),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            title: 'Telefone',
            subtitle: paciente.telefone,
          ),
          const Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/editar_dados');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Função de editar em desenvolvimento!')),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle ?? 'Não informado',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}