import 'dart:convert';

class Exame {
  final String id;
  final String nomeExame;
  final DateTime dataSolicitacao;
  final String nomeProfissionalSolicitante;
  // NOVOS CAMPOS ADICIONADOS
  final DateTime? dataRealizacao;
  final String? resultado;
  final String? urlAnexo;

  Exame({
    required this.id,
    required this.nomeExame,
    required this.dataSolicitacao,
    required this.nomeProfissionalSolicitante,
    this.dataRealizacao,
    this.resultado,
    this.urlAnexo,
  });

  factory Exame.fromJson(Map<String, dynamic> json) {
    return Exame(
      id: json['id'] ?? '',
      nomeExame: json['nomeExame'] ?? 'Exame não especificado',
      dataSolicitacao: json['dataSolicitacao'] != null
          ? DateTime.parse(json['dataSolicitacao'])
          : DateTime.now(),
      nomeProfissionalSolicitante: json['nomeProfissionalSolicitante'] ?? 'Médico não informado',
      dataRealizacao: json['dataRealizacao'] != null ? DateTime.parse(json['dataRealizacao']) : null,
      resultado: json['resultado'],
      urlAnexo: json['urlAnexo'],
    );
  }
}