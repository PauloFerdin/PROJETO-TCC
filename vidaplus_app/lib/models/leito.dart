import 'package:vidaplus_app/models/status_leito.dart';

class Leito {
  final String id;
  final String numeroDoLeito;
  final String setor;
  StatusLeito status; // Não é final para podermos atualizá-lo na UI

  Leito({
    required this.id,
    required this.numeroDoLeito,
    required this.setor,
    required this.status,
  });

  factory Leito.fromJson(Map<String, dynamic> json) {
    return Leito(
      id: json['id'] ?? '',
      numeroDoLeito: json['numeroDoLeito'] ?? 'N/A',
      setor: json['setor'] ?? 'N/A',
      status: StatusLeito.fromString(json['status'] ?? 'LIVRE'),
    );
  }
}