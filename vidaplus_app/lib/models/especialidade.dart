class Especialidade {
  final String id;
  final String nome;

  Especialidade({
    required this.id,
    required this.nome,
  });

  factory Especialidade.fromJson(Map<String, dynamic> json) {
    return Especialidade(
      id: json['id'],
      nome: json['nome'],
    );
  }
}