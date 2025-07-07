package br.com.vidaplus.vidaplus_backend_tcc.repository;

import br.com.vidaplus.vidaplus_backend_tcc.entity.Paciente;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PacienteRepository extends JpaRepository<Paciente, String> {
    Optional<Paciente> findByUserEmail(String email);
}
