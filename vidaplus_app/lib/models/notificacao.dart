import 'dart:convert';

class Notificacao {
  final String id;
  final String mensagem;
  final DateTime dataCriacao;
  late final bool lida;

  Notificacao({
    required this.id,
    required this.mensagem,
    required this.dataCriacao,
    required this.lida,
  });

  factory Notificacao.fromJson(Map<String, dynamic> json) {
    return Notificacao(
      id: json['id'] ?? '',
      mensagem: json['mensagem'] ?? 'Mensagem indisponível',
      // Converte a string de data/hora do JSON para um objeto DateTime
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.parse(json['dataCriacao'])
          : DateTime.now(),
      lida: json['lida'] ?? false,
    );
  }
}