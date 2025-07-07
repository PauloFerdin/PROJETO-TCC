package br.com.vidaplus.vidaplus_backend_tcc.dto;

import br.com.vidaplus.vidaplus_backend_tcc.entity.UserRole;

public record UserDTO(
        String id,
        String nome,
        String email,
        UserRole perfil,
        PacienteDTO paciente,
        ProfissionalDTO profissional
) {}