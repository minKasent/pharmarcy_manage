package com.pharmacy.management.service;

import com.pharmacy.management.dto.MedicineDTO;
import com.pharmacy.management.entity.Medicine;
import com.pharmacy.management.entity.User;
import com.pharmacy.management.exception.ResourceAlreadyExistsException;
import com.pharmacy.management.exception.ResourceNotFoundException;
import com.pharmacy.management.repository.MedicineRepository;
import com.pharmacy.management.repository.UserRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class MedicineService {
    
    @Autowired
    private MedicineRepository medicineRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    // Lấy danh sách tất cả thuốc
    public List<MedicineDTO> getAllMedicines() {
        return medicineRepository.findByIsActiveTrue().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Lấy danh sách thuốc với phân trang
    public Page<MedicineDTO> getAllMedicines(Pageable pageable) {
        return medicineRepository.findByIsActiveTrue(pageable)
                .map(this::convertToDTO);
    }
    
    // Tìm kiếm thuốc
    public Page<MedicineDTO> searchMedicines(String keyword, Pageable pageable) {
        return medicineRepository.searchMedicines(keyword, pageable)
                .map(this::convertToDTO);
    }
    
    // Lấy thông tin thuốc theo ID
    public MedicineDTO getMedicineById(Long id) {
        Medicine medicine = medicineRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy thuốc với ID: " + id));
        return convertToDTO(medicine);
    }
    
    // Thêm thuốc mới
    @Transactional
    public MedicineDTO createMedicine(MedicineDTO medicineDTO) {
        if (medicineRepository.existsByCode(medicineDTO.getCode())) {
            throw new ResourceAlreadyExistsException("Mã thuốc đã tồn tại: " + medicineDTO.getCode());
        }
        
        Medicine medicine = new Medicine();
        BeanUtils.copyProperties(medicineDTO, medicine, "id", "createdAt", "updatedAt");
        
        // Set người tạo
        User currentUser = getCurrentUser();
        medicine.setCreatedBy(currentUser);
        
        Medicine savedMedicine = medicineRepository.save(medicine);
        return convertToDTO(savedMedicine);
    }
    
    // Cập nhật thông tin thuốc
    @Transactional
    public MedicineDTO updateMedicine(Long id, MedicineDTO medicineDTO) {
        Medicine medicine = medicineRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy thuốc với ID: " + id));
        
        // Kiểm tra mã thuốc nếu thay đổi
        if (!medicine.getCode().equals(medicineDTO.getCode()) && 
            medicineRepository.existsByCode(medicineDTO.getCode())) {
            throw new ResourceAlreadyExistsException("Mã thuốc đã tồn tại: " + medicineDTO.getCode());
        }
        
        BeanUtils.copyProperties(medicineDTO, medicine, "id", "createdAt", "updatedAt", "createdBy");
        
        // Set người cập nhật
        User currentUser = getCurrentUser();
        medicine.setUpdatedBy(currentUser);
        
        Medicine updatedMedicine = medicineRepository.save(medicine);
        return convertToDTO(updatedMedicine);
    }
    
    // Xóa thuốc (soft delete)
    @Transactional
    public void deleteMedicine(Long id) {
        Medicine medicine = medicineRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy thuốc với ID: " + id));
        
        medicine.setActive(false);
        medicineRepository.save(medicine);
    }
    
    // Xóa thuốc vĩnh viễn
    @Transactional
    public void deleteMedicinePermanently(Long id) {
        if (!medicineRepository.existsById(id)) {
            throw new ResourceNotFoundException("Không tìm thấy thuốc với ID: " + id);
        }
        medicineRepository.deleteById(id);
    }
    
    // Lấy danh sách thuốc sắp hết hạn
    public List<MedicineDTO> getExpiringMedicines(java.time.LocalDate beforeDate) {
        return medicineRepository.findByExpiryDateBefore(beforeDate).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Lấy danh sách thuốc sắp hết hàng
    public List<MedicineDTO> getLowStockMedicines() {
        return medicineRepository.findAll().stream()
                .filter(m -> {
                    Integer minimumStock = m.getMinimumStock();
                    if (minimumStock == null) {
                        minimumStock = 10; // Giá trị mặc định
                    }
                    return m.getQuantityInStock() <= minimumStock;
                })
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Helper methods
    private MedicineDTO convertToDTO(Medicine medicine) {
        MedicineDTO dto = new MedicineDTO();
        BeanUtils.copyProperties(medicine, dto);
        return dto;
    }
    
    private User getCurrentUser() {
        String username = ((UserDetails) SecurityContextHolder.getContext()
                .getAuthentication().getPrincipal()).getUsername();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }
}