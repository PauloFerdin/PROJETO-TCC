package br.com.vidaplus.vidaplus_backend_tcc.dto;

import br.com.vidaplus.vidaplus_backend_tcc.entity.UserRole;

public record LoginResponse(
        String nome,
        String email,
        UserRole perfil,
        String token
) {}