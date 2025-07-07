package br.com.vidaplus.vidaplus_backend_tcc.repository;

import br.com.vidaplus.vidaplus_backend_tcc.entity.Consulta;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ConsultaRepository extends JpaRepository<Consulta, String> {
    List<Consulta> findByPacienteUserEmail(String email);
    List<Consulta> findByProfissionalUserEmail(String email);
}
