package com.pharmacy.management.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MedicineDTO {
    
    private Long id;
    
    @NotBlank(message = "Tên thuốc không được để trống")
    private String name;
    
    private String genericName;
    
    @NotBlank(message = "Mã thuốc không được để trống")
    private String code;
    
    private String description;
    
    @NotBlank(message = "Nhà sản xuất không được để trống")
    private String manufacturer;
    
    private String unitOfMeasure;
    
    @NotNull(message = "Giá không được để trống")
    @Positive(message = "Giá phải lớn hơn 0")
    private BigDecimal price;
    
    @NotNull(message = "Số lượng tồn kho không được để trống")
    private Integer quantityInStock;
    
    private Integer minimumStock;
    
    private String batchNumber;
    
    private LocalDate expiryDate;
    
    private String category;
    
    private String storageCondition;
    
    private boolean prescriptionRequired;
    
    private boolean isActive = true;
    
    private String imageUrl;
}