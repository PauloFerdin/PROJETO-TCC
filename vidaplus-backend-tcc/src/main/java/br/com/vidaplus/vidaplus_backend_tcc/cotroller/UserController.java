package br.com.vidaplus.vidaplus_backend_tcc.cotroller;

import br.com.vidaplus.vidaplus_backend_tcc.entity.User;
import br.com.vidaplus.vidaplus_backend_tcc.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserRepository userRepository;

    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @PostMapping
    public User createUser(@RequestBody User user) {
        user.setSenha(new BCryptPasswordEncoder().encode(user.getSenha()));
        return userRepository.save(user);
    }
}
