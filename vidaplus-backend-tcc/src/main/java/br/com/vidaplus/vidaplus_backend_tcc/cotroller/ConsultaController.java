package br.com.vidaplus.vidaplus_backend_tcc.cotroller;

import br.com.vidaplus.vidaplus_backend_tcc.dto.NovaConsultaRequest;
import br.com.vidaplus.vidaplus_backend_tcc.entity.Consulta;
import br.com.vidaplus.vidaplus_backend_tcc.entity.User;
import br.com.vidaplus.vidaplus_backend_tcc.repository.ConsultaRepository;
import br.com.vidaplus.vidaplus_backend_tcc.repository.PacienteRepository;
import br.com.vidaplus.vidaplus_backend_tcc.repository.ProfissionalRepository;
import br.com.vidaplus.vidaplus_backend_tcc.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/consultas")
@RequiredArgsConstructor
public class ConsultaController {

    private final ConsultaRepository consultaRepository;
    private final UserRepository userRepository;
    private final PacienteRepository pacienteRepository;
    private final ProfissionalRepository profissionalRepository;

    @PostMapping
    public Consulta criarConsulta(@RequestBody NovaConsultaRequest request) {
        var paciente = pacienteRepository.findById(request.pacienteId())
                .orElseThrow(() -> new RuntimeException("Paciente não encontrado"));

        var profissional = profissionalRepository.findById(request.profissionalId())
                .orElseThrow(() -> new RuntimeException("Profissional não encontrado"));

        var consulta = new Consulta();
        consulta.setDescricao(request.descricao());
        consulta.setDataHora(LocalDateTime.now());
        consulta.setPaciente(paciente);
        consulta.setProfissional(profissional);

        return consultaRepository.save(consulta);
    }


    @GetMapping("/minhas")
    public List<Consulta> listarMinhasConsultas(Authentication auth) {
        String email = auth.getName();

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        return switch (user.getPerfil()) {
            case PACIENTE -> consultaRepository.findByPacienteUserEmail(email);
            case PROFISSIONAL -> consultaRepository.findByProfissionalUserEmail(email);
            default -> throw new RuntimeException("Perfil não autorizado para listar consultas");
        };
    }
}
