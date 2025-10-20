package com.pharmacy.management.controller;

import com.pharmacy.management.dto.MedicineDTO;
import com.pharmacy.management.service.MedicineService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/medicines")
public class MedicineController {
    
    @Autowired
    private MedicineService medicineService;
    
    // Lấy danh sách tất cả thuốc
    @GetMapping
    public ResponseEntity<List<MedicineDTO>> getAllMedicines() {
        List<MedicineDTO> medicines = medicineService.getAllMedicines();
        return ResponseEntity.ok(medicines);
    }
    
    // Lấy danh sách thuốc với phân trang
    @GetMapping("/page")
    public ResponseEntity<Page<MedicineDTO>> getAllMedicinesPaginated(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy,
            @RequestParam(defaultValue = "DESC") String sortDirection) {
        
        Sort.Direction direction = sortDirection.equalsIgnoreCase("ASC") 
            ? Sort.Direction.ASC : Sort.Direction.DESC;
        Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortBy));
        
        Page<MedicineDTO> medicines = medicineService.getAllMedicines(pageable);
        return ResponseEntity.ok(medicines);
    }
    
    // Tìm kiếm thuốc
    @GetMapping("/search")
    public ResponseEntity<Page<MedicineDTO>> searchMedicines(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Pageable pageable = PageRequest.of(page, size);
        Page<MedicineDTO> medicines = medicineService.searchMedicines(keyword, pageable);
        return ResponseEntity.ok(medicines);
    }
    
    // Lấy thông tin thuốc theo ID
    @GetMapping("/{id}")
    public ResponseEntity<MedicineDTO> getMedicineById(@PathVariable Long id) {
        MedicineDTO medicine = medicineService.getMedicineById(id);
        return ResponseEntity.ok(medicine);
    }
    
    // Thêm thuốc mới (Chỉ ADMIN và MANAGER)
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<MedicineDTO> createMedicine(@Valid @RequestBody MedicineDTO medicineDTO) {
        MedicineDTO createdMedicine = medicineService.createMedicine(medicineDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdMedicine);
    }
    
    // Cập nhật thông tin thuốc (Chỉ ADMIN và MANAGER)
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<MedicineDTO> updateMedicine(
            @PathVariable Long id,
            @Valid @RequestBody MedicineDTO medicineDTO) {
        MedicineDTO updatedMedicine = medicineService.updateMedicine(id, medicineDTO);
        return ResponseEntity.ok(updatedMedicine);
    }
    
    // Xóa thuốc (soft delete) (Chỉ ADMIN)
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, String>> deleteMedicine(@PathVariable Long id) {
        medicineService.deleteMedicine(id);
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Xóa thuốc thành công!");
        
        return ResponseEntity.ok(response);
    }
    
    // Lấy danh sách thuốc sắp hết hạn
    @GetMapping("/expiring")
    public ResponseEntity<List<MedicineDTO>> getExpiringMedicines(
            @RequestParam(defaultValue = "30") int daysBeforeExpiry) {
        LocalDate beforeDate = LocalDate.now().plusDays(daysBeforeExpiry);
        List<MedicineDTO> medicines = medicineService.getExpiringMedicines(beforeDate);
        return ResponseEntity.ok(medicines);
    }
    
    // Lấy danh sách thuốc sắp hết hàng
    @GetMapping("/low-stock")
    public ResponseEntity<List<MedicineDTO>> getLowStockMedicines() {
        List<MedicineDTO> medicines = medicineService.getLowStockMedicines();
        return ResponseEntity.ok(medicines);
    }
}