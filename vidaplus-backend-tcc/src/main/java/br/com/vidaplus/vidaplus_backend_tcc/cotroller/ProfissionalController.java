package br.com.vidaplus.vidaplus_backend_tcc.cotroller;

import br.com.vidaplus.vidaplus_backend_tcc.entity.Profissional;
import br.com.vidaplus.vidaplus_backend_tcc.repository.ProfissionalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/profissional")
@RequiredArgsConstructor
public class ProfissionalController {

    private final ProfissionalRepository profissionalRepository;

    @GetMapping
    public List<Profissional> listarTodos() {
        return profissionalRepository.findAll();
    }
}
