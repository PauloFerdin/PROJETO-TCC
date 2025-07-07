package br.com.vidaplus.vidaplus_backend_tcc.cotroller;

import br.com.vidaplus.vidaplus_backend_tcc.dto.*;
import br.com.vidaplus.vidaplus_backend_tcc.entity.Paciente;
import br.com.vidaplus.vidaplus_backend_tcc.entity.Profissional;
import br.com.vidaplus.vidaplus_backend_tcc.entity.User;
import br.com.vidaplus.vidaplus_backend_tcc.entity.UserRole;
import br.com.vidaplus.vidaplus_backend_tcc.repository.PacienteRepository;
import br.com.vidaplus.vidaplus_backend_tcc.repository.ProfissionalRepository;
import br.com.vidaplus.vidaplus_backend_tcc.repository.UserRepository;
import br.com.vidaplus.vidaplus_backend_tcc.security.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;


@RequiredArgsConstructor
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserRepository userRepository;
    private final JwtService jwtService;
    private final PacienteRepository pacienteRepository;
    private final ProfissionalRepository profissionalRepository;
    private final BCryptPasswordEncoder passwordEncoder; // injeta a instância
    private final AuthenticationManager authenticationManager;

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.email(), request.senha())
        );

        User usuario = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado"));

        // Cria o token
        String token = jwtService.generateToken(usuario.getEmail());

        // Monta DTOs
        PacienteDTO pacienteDTO = usuario.getPaciente() != null ? new PacienteDTO(
                usuario.getPaciente().getId(),
                usuario.getPaciente().getNome(),
                usuario.getPaciente().getCpf(),
                usuario.getPaciente().getTelefone()
        ) : null;

        ProfissionalDTO profissionalDTO = usuario.getProfissional() != null ? new ProfissionalDTO(
                usuario.getProfissional().getId(),
                usuario.getProfissional().getNome(),
                usuario.getProfissional().getEspecialidade(),
                usuario.getProfissional().getRegistro()
        ) : null;

        UserDTO userDTO = new UserDTO(
                usuario.getId(),
                usuario.getNome(),
                usuario.getEmail(),
                usuario.getPerfil(),
                pacienteDTO,
                profissionalDTO
        );

        return ResponseEntity.ok(new AuthResponse(token, userDTO));
    }


    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest request) {
        User novoUsuario = new User();
        novoUsuario.setNome(request.nome());
        novoUsuario.setEmail(request.email());
        novoUsuario.setSenha(passwordEncoder.encode(request.senha()));
        novoUsuario.setPerfil(request.perfil());

        if (request.perfil() == UserRole.PACIENTE) {
            Paciente paciente = new Paciente();
            paciente.setNome(novoUsuario.getNome());
            paciente.setUser(novoUsuario);
            novoUsuario.setPaciente(paciente);
        } else if (request.perfil() == UserRole.PROFISSIONAL) {
            Profissional profissional = new Profissional();
            profissional.setNome(novoUsuario.getNome());
            profissional.setUser(novoUsuario);
            novoUsuario.setProfissional(profissional);
        }

        userRepository.save(novoUsuario);

        // Monta o DTO
        PacienteDTO pacienteDTO = novoUsuario.getPaciente() != null ? new PacienteDTO(
                novoUsuario.getPaciente().getId(),
                novoUsuario.getPaciente().getNome(),
                novoUsuario.getPaciente().getCpf(),
                novoUsuario.getPaciente().getTelefone()
        ) : null;

        ProfissionalDTO profissionalDTO = novoUsuario.getProfissional() != null ? new ProfissionalDTO(
                novoUsuario.getProfissional().getId(),
                novoUsuario.getProfissional().getNome(),
                novoUsuario.getProfissional().getEspecialidade(),
                novoUsuario.getProfissional().getRegistro()
        ) : null;

        UserDTO userDTO = new UserDTO(
                novoUsuario.getId(),
                novoUsuario.getNome(),
                novoUsuario.getEmail(),
                novoUsuario.getPerfil(),
                pacienteDTO,
                profissionalDTO
        );

        String token = jwtService.generateToken(novoUsuario.getEmail());

        return ResponseEntity.ok(new AuthResponse(token, userDTO));
    }

    @GetMapping("/me")
    public ResponseEntity<UserDTO> getCurrentUser(@AuthenticationPrincipal User user) {
        PacienteDTO pacienteDTO = null;
        ProfissionalDTO profissionalDTO = null;

        if (user.getPaciente() != null) {
            var paciente = user.getPaciente();
            pacienteDTO = new PacienteDTO(
                    paciente.getId(),
                    paciente.getNome(),
                    paciente.getCpf(),
                    paciente.getTelefone()
            );
        }

        if (user.getProfissional() != null) {
            var profissional = user.getProfissional();
            profissionalDTO = new ProfissionalDTO(
                    profissional.getId(),
                    profissional.getNome(),
                    profissional.getEspecialidade(),
                    profissional.getRegistro()
            );
        }

        UserDTO dto = new UserDTO(
                user.getId(),
                user.getNome(),
                user.getEmail(),
                user.getPerfil(),
                pacienteDTO,
                profissionalDTO
        );

        return ResponseEntity.ok(dto);
    }
}