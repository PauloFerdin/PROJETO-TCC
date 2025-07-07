class Profissional {
  final String id;
  final String nome;
  final String? registro;
  final String? especialidade;

  Profissional({
    required this.id,
    required this.nome,
    this.registro,
    this.especialidade,
  });

  factory Profissional.fromJson(Map<String, dynamic> json) {
    return Profissional(
      id: json['id'],
      nome: json['nome'],
      registro: json['registro'],
      especialidade: json['especialidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'registro': registro,
      'especialidade': especialidade,
    };
  }
}