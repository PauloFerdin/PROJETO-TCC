import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vidaplus_app/models/relatorio_financeiro.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  final _apiService = AuthService();

  // Define o intervalo de datas padrão para o mês atual
  DateTime _dataInicio = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _dataFim = DateTime.now();

  Future<RelatorioFinanceiro>? _relatorioFuture;

  @override
  void initState() {
    super.initState();
    _gerarRelatorio();
  }

  void _gerarRelatorio() {
    final inicioFormatado = DateFormat('yyyy-MM-dd').format(_dataInicio);
    final fimFormatado = DateFormat('yyyy-MM-dd').format(_dataFim);

    setState(() {
      _relatorioFuture = _apiService.getRelatorioFinanceiro(inicioFormatado, fimFormatado);
    });
  }

  Future<void> _selecionarIntervalo(BuildContext context) async {
    final novoIntervalo = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _dataInicio, end: _dataFim),
    );

    if (novoIntervalo != null) {
      setState(() {
        _dataInicio = novoIntervalo.start;
        _dataFim = novoIntervalo.end;
      });
      _gerarRelatorio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório Financeiro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: 'Selecionar Período',
            onPressed: () => _selecionarIntervalo(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Período: ${DateFormat('d/MM/y').format(_dataInicio)} - ${DateFormat('d/MM/y').format(_dataFim)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<RelatorioFinanceiro>(
                future: _relatorioFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao gerar relatório: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Nenhum dado encontrado para este período.'));
                  }

                  final relatorio = snapshot.data!;
                  return _buildRelatorioGrid(relatorio);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatorioGrid(RelatorioFinanceiro relatorio) {
    final formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildRelatorioCard(
          'Faturamento Total',
          formatadorMoeda.format(relatorio.faturamentoTotal),
          Icons.monetization_on_outlined,
          Colors.green,
        ),
        _buildRelatorioCard(
          'Total de Consultas',
          relatorio.totalConsultas.toString(),
          Icons.medical_services_outlined,
          Colors.blue,
        ),
        _buildRelatorioCard(
          'Faturamento Consultas',
          formatadorMoeda.format(relatorio.faturamentoConsultas),
          Icons.receipt_long_outlined,
          Colors.orange,
        ),
        _buildRelatorioCard(
          'Total de Exames',
          relatorio.totalExames.toString(),
          Icons.science_outlined,
          Colors.purple,
        ),
        _buildRelatorioCard(
          'Faturamento Exames',
          formatadorMoeda.format(relatorio.faturamentoExames),
          Icons.receipt_outlined,
          Colors.deepOrange,
        ),
      ],
    );
  }

  Widget _buildRelatorioCard(String titulo, String valor, IconData icone, Color cor) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, size: 32, color: cor),
            const Spacer(),
            Text(titulo, style: const TextStyle(fontSize: 16)),
            Text(valor, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
