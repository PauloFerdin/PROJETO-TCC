import 'dart:convert';
import 'dart:math';

class RelatorioFinanceiro {
  final double faturamentoConsultas;
  final double faturamentoExames;
  final double faturamentoTotal;
  final int totalConsultas;
  final int totalExames;

  RelatorioFinanceiro({
    required this.faturamentoConsultas,
    required this.faturamentoExames,
    required this.faturamentoTotal,
    required this.totalConsultas,
    required this.totalExames,
  });

  factory RelatorioFinanceiro.fromJson(Map<String, dynamic> json) {
    // A API retorna BigDecimal, que vem como número no JSON.
    // Convertemos para double para usar no Dart.
    return RelatorioFinanceiro(
      faturamentoConsultas: (json['faturamentoConsultas'] as num?)?.toDouble() ?? 0.0,
      faturamentoExames: (json['faturamentoExames'] as num?)?.toDouble() ?? 0.0,
      faturamentoTotal: (json['faturamentoTotal'] as num?)?.toDouble() ?? 0.0,
      totalConsultas: json['totalConsultas'] ?? 0,
      totalExames: json['totalExames'] ?? 0,
    );
  }
}