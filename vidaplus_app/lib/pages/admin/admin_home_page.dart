import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vidaplus_app/services/auth_manager.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthManager.instance.logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildAdminCard(
            context,
            icon: Icons.king_bed_outlined,
            label: 'Gestão de Leitos',
            onTap: () => context.push('/gestao_leitos'),
          ),
          _buildAdminCard(
            context,
            icon: Icons.inventory_2_outlined,
            label: 'Gestão de Suprimentos',
            onTap: () => context.push('/gestao_suprimentos'),
          ),
          _buildAdminCard(
            context,
            icon: Icons.bar_chart_outlined,
            label: 'Relatórios Financeiros',
            onTap: () => context.push('/relatorios'),
          ),
          // Adicione outros cards para futuras funcionalidades de admin aqui
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}