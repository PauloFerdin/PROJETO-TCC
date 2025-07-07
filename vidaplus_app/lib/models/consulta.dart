class Consulta {
  final String id;
  final String nomePaciente;
  final String nomeProfissional;
  final String nomeEspecialidade;
  final DateTime? dataConsulta;
  final String horaConsulta;
  final String status;
  final String? anotacoesClinicas;

  Consulta({
    required this.id,
    required this.nomePaciente,
    required this.nomeProfissional,
    required this.nomeEspecialidade,
    this.dataConsulta,
    required this.horaConsulta,
    required this.status,
    this.anotacoesClinicas,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(

      id: json['id'] ?? '',
      nomePaciente: json['nomePaciente'] ?? 'Paciente não informado',
      nomeProfissional: json['nomeProfissional'] ?? 'Profissional não informado',
      nomeEspecialidade: json['nomeEspecialidade'] ?? 'Especialidade não informada',

      dataConsulta: json['dataConsulta'] != null ? DateTime.parse(json['dataConsulta']) : null,

      horaConsulta: (json['horaConsulta'] as String?)?.substring(0, 5) ?? '--:--',
      status: json['status'] ?? 'Indefinido',
      anotacoesClinicas: json['anotacoesClinicas'],
    );
  }
}