package br.com.vidaplus.vidaplus_backend_tcc.dto;

import br.com.vidaplus.vidaplus_backend_tcc.entity.UserRole;

public record RegisterResponse(
        String nome,
        String email,
        UserRole perfil,
        String token
) {}