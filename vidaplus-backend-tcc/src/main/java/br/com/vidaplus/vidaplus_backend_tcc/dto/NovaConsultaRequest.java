package br.com.vidaplus.vidaplus_backend_tcc.dto;

public record NovaConsultaRequest(
        String descricao,
        String pacienteId,
        String profissionalId
) {}
