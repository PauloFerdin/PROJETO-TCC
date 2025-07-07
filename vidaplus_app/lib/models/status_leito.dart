enum StatusLeito {
  LIVRE,
  OCUPADO,
  EM_LIMPEZA,
  EM_MANUTENCAO;

  // Helper para converter a string do backend para o nosso enum
  static StatusLeito fromString(String status) {
    return StatusLeito.values.firstWhere(
          (e) => e.name == status.toUpperCase(),
      orElse: () => StatusLeito.LIVRE, // Valor padrão
    );
  }
}