import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vidaplus_app/models/suprimento.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class GestaoSuprimentosPage extends StatefulWidget {
  const GestaoSuprimentosPage({super.key});

  @override
  State<GestaoSuprimentosPage> createState() => _GestaoSuprimentosPageState();
}

class _GestaoSuprimentosPageState extends State<GestaoSuprimentosPage> {
  late Future<List<Suprimento>> _suprimentosFuture;
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchSuprimentos();
  }

  void _fetchSuprimentos() {
    setState(() {
      _suprimentosFuture = _apiService.getSuprimentos();
    });
  }

  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();
    final nomeController = TextEditingController();
    final descController = TextEditingController();
    final qtdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Novo Suprimento'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome do Item'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(controller: descController, decoration: const InputDecoration(labelText: 'Descrição')),
              TextFormField(controller: qtdController, decoration: const InputDecoration(labelText: 'Quantidade Inicial'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop();
                await _criarSuprimento(nomeController.text, descController.text, int.tryParse(qtdController.text) ?? 0);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  Future<void> _criarSuprimento(String nome, String desc, int qtd) async {
    try {
      await _apiService.criarSuprimento(nome: nome, descricao: desc, quantidadeInicial: qtd);
      _fetchSuprimentos();
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}'), backgroundColor: Colors.red));
    }
  }

  // --- MÉTODO DE ATUALIZAÇÃO MELHORADO ---
  void _showUpdateStockDialog(Suprimento suprimento) {
    final formKey = GlobalKey<FormState>();
    final qtdController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(suprimento.nome),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estoque atual: ${suprimento.quantidadeEmEstoque}'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: qtdController,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira uma quantidade.';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Insira um número válido.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            // Botão para REMOVER do estoque
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final quantidade = int.parse(qtdController.text);
                  Navigator.of(context).pop();
                  _atualizarEstoque(suprimento, -quantidade); // Envia como negativo
                }
              },
              child: const Text('Remover', style: TextStyle(color: Colors.red)),
            ),
            // Botão para ADICIONAR ao estoque
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final quantidade = int.parse(qtdController.text);
                  Navigator.of(context).pop();
                  _atualizarEstoque(suprimento, quantidade); // Envia como positivo
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        ));
  }

  Future<void> _atualizarEstoque(Suprimento suprimento, int quantidade) async {
    try {
      await _apiService.atualizarEstoque(suprimento.id, quantidade);
      _fetchSuprimentos(); // Atualiza a lista para refletir a mudança
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar estoque: ${e.toString()}'), backgroundColor: Colors.red));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Suprimentos'),
        actions: [IconButton(icon: const Icon(Icons.add), tooltip: 'Adicionar Suprimento', onPressed: _showAddDialog)],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchSuprimentos(),
        child: FutureBuilder<List<Suprimento>>(
          future: _suprimentosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar suprimentos: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum suprimento encontrado.'));
            }

            final suprimentos = snapshot.data!;
            return ListView.builder(
              itemCount: suprimentos.length,
              itemBuilder: (context, index) {
                final item = suprimentos[index];
                return ListTile(
                  title: Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.descricao ?? 'Sem descrição'),
                  trailing: Text('Estoque: ${item.quantidadeEmEstoque}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onTap: () => _showUpdateStockDialog(item),
                );
              },
            );
          },
        ),
      ),
    );
  }
}