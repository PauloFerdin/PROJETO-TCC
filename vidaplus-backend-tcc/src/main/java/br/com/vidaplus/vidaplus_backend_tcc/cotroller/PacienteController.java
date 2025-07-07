package br.com.vidaplus.vidaplus_backend_tcc.cotroller;

import br.com.vidaplus.vidaplus_backend_tcc.entity.Paciente;
import br.com.vidaplus.vidaplus_backend_tcc.repository.PacienteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pacientes")
@RequiredArgsConstructor
public class PacienteController {

    private final PacienteRepository pacienteRepository;

    @GetMapping("/me")
    public Paciente getPacienteLogado(Authentication authentication) {
        String email = authentication.getName();
        return pacienteRepository.findByUserEmail(email)
                .orElseThrow(() -> new RuntimeException("Paciente não encontrado"));
    }

}
