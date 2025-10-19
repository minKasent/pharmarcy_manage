package com.pharmacy.management.repository;

import com.pharmacy.management.entity.Medicine;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface MedicineRepository extends JpaRepository<Medicine, Long> {
    
    Optional<Medicine> findByCode(String code);
    
    Boolean existsByCode(String code);
    
    List<Medicine> findByIsActiveTrue();
    
    Page<Medicine> findByIsActiveTrue(Pageable pageable);
    
    @Query("SELECT m FROM Medicine m WHERE " +
           "LOWER(m.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(m.genericName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(m.code) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    Page<Medicine> searchMedicines(@Param("keyword") String keyword, Pageable pageable);
    
    List<Medicine> findByExpiryDateBefore(LocalDate date);
    
    List<Medicine> findByQuantityInStockLessThanEqual(Integer quantity);
    
    List<Medicine> findByCategory(String category);
}