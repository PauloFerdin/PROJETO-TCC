import 'dart:convert';

class Suprimento {
  final String id;
  final String nome;
  final String? descricao;
  int quantidadeEmEstoque;

  Suprimento({
    required this.id,
    required this.nome,
    this.descricao,
    required this.quantidadeEmEstoque,
  });

  factory Suprimento.fromJson(Map<String, dynamic> json) {
    return Suprimento(
      id: json['id'] ?? '',
      nome: json['nome'] ?? 'Nome indisponível',
      descricao: json['descricao'],
      quantidadeEmEstoque: json['quantidadeEmEstoque'] ?? 0,
    );
  }
}