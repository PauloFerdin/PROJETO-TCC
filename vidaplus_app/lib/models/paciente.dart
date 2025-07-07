class Paciente {
  final String id;
  final String nome;
  final String? cpf;
  final String? telefone;

  Paciente({
    required this.id,
    required this.nome,
    this.cpf,
    this.telefone,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      telefone: json['telefone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
    };
  }
}