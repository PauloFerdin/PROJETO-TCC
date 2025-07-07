package br.com.vidaplus.vidaplus_backend_tcc.dto;

import br.com.vidaplus.vidaplus_backend_tcc.entity.UserRole;

public record RegisterRequest(
        String nome,
        String email,
        String senha,
        UserRole perfil
) {}
