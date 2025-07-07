package br.com.vidaplus.vidaplus_backend_tcc.entity;

import org.springframework.security.core.GrantedAuthority;

public enum UserRole implements GrantedAuthority {
    ADMIN, PACIENTE, PROFISSIONAL;

    @Override
    public String getAuthority() {
        return "ROLE_" + this.name();
    }
}