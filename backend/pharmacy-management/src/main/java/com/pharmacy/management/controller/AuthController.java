package com.pharmacy.management.controller;

import com.pharmacy.management.dto.ChangePasswordDTO;
import com.pharmacy.management.dto.JwtResponse;
import com.pharmacy.management.dto.LoginDTO;
import com.pharmacy.management.dto.RegisterDTO;
import com.pharmacy.management.entity.User;
import com.pharmacy.management.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {
    @Autowired
    private AuthService authService;
    
    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginDTO loginDTO) {
        JwtResponse jwtResponse = authService.authenticateUser(loginDTO);
        return ResponseEntity.ok(jwtResponse);
    }
    
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@Valid @RequestBody RegisterDTO registerDTO) {
        User user = authService.registerUser(registerDTO);
        
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Đăng ký thành công!");
        response.put("user", user);
        
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
    
    @PostMapping("/logout")
    public ResponseEntity<?> logoutUser() {
        authService.logout();
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Đăng xuất thành công!");
        
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/change-password")
    public ResponseEntity<?> changePassword(@Valid @RequestBody ChangePasswordDTO changePasswordDTO) {
        authService.changePassword(changePasswordDTO);
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Đổi mật khẩu thành công!");
        
        return ResponseEntity.ok(response);
    }
}