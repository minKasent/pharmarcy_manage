package com.pharmacy.management.service;

import com.pharmacy.management.dto.JwtResponse;
import com.pharmacy.management.dto.LoginDTO;
import com.pharmacy.management.dto.RegisterDTO;
import com.pharmacy.management.entity.User;
import com.pharmacy.management.exception.ResourceAlreadyExistsException;
import com.pharmacy.management.repository.UserRepository;
import com.pharmacy.management.security.UserDetailsImpl;
import com.pharmacy.management.security.jwt.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {
    
    @Autowired
    private AuthenticationManager authenticationManager;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private JwtUtils jwtUtils;
    
    public JwtResponse authenticateUser(LoginDTO loginDTO) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginDTO.getUsername(), loginDTO.getPassword()));
        
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);
        
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        String role = userDetails.getAuthorities().stream()
                .findFirst()
                .map(item -> item.getAuthority())
                .orElse("");
        
        return new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                role);
    }
    
    @Transactional
    public User registerUser(RegisterDTO registerDTO) {
        if (userRepository.existsByUsername(registerDTO.getUsername())) {
            throw new ResourceAlreadyExistsException("Username đã tồn tại!");
        }
        
        if (userRepository.existsByEmail(registerDTO.getEmail())) {
            throw new ResourceAlreadyExistsException("Email đã được sử dụng!");
        }
        
        User user = new User();
        user.setUsername(registerDTO.getUsername());
        user.setPassword(passwordEncoder.encode(registerDTO.getPassword()));
        user.setEmail(registerDTO.getEmail());
        user.setFullName(registerDTO.getFullName());
        user.setPhoneNumber(registerDTO.getPhoneNumber());
        user.setRole(User.UserRole.STAFF);
        user.setActive(true);
        
        return userRepository.save(user);
    }
    
    public void logout() {
        SecurityContextHolder.clearContext();
    }
}