import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/medicine_model.dart';
import '../../viewmodels/medicine_viewmodel.dart';

class AddMedicineScreen extends StatefulWidget {
  final MedicineModel? medicine;
  
  const AddMedicineScreen({
    Key? key,
    this.medicine,
  }) : super(key: key);

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _genericNameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _unitController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minimumStockController = TextEditingController();
  final _batchNumberController = TextEditingController();
  final _categoryController = TextEditingController();
  final _storageConditionController = TextEditingController();
  
  DateTime? _expiryDate;
  bool _prescriptionRequired = false;
  
  bool get isEditing => widget.medicine != null;
  
  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadMedicineData();
    }
  }
  
  void _loadMedicineData() {
    final medicine = widget.medicine!;
    _nameController.text = medicine.name;
    _genericNameController.text = medicine.genericName ?? '';
    _codeController.text = medicine.code;
    _descriptionController.text = medicine.description ?? '';
    _manufacturerController.text = medicine.manufacturer;
    _unitController.text = medicine.unitOfMeasure ?? '';
    _priceController.text = medicine.price.toString();
    _quantityController.text = medicine.quantityInStock.toString();
    _minimumStockController.text = medicine.minimumStock?.toString() ?? '';
    _batchNumberController.text = medicine.batchNumber ?? '';
    _categoryController.text = medicine.category ?? '';
    _storageConditionController.text = medicine.storageCondition ?? '';
    _expiryDate = medicine.expiryDate;
    _prescriptionRequired = medicine.prescriptionRequired;
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _genericNameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _manufacturerController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _minimumStockController.dispose();
    _batchNumberController.dispose();
    _categoryController.dispose();
    _storageConditionController.dispose();
    super.dispose();
  }
  
  Future<void> _selectExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    
    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }
  
  Future<void> _saveMedicine() async {
    if (_formKey.currentState!.validate()) {
      final medicineViewModel = Provider.of<MedicineViewModel>(context, listen: false);
      
      final medicine = MedicineModel(
        id: widget.medicine?.id,
        name: _nameController.text.trim(),
        genericName: _genericNameController.text.trim().isEmpty 
            ? null : _genericNameController.text.trim(),
        code: _codeController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null : _descriptionController.text.trim(),
        manufacturer: _manufacturerController.text.trim(),
        unitOfMeasure: _unitController.text.trim().isEmpty 
            ? null : _unitController.text.trim(),
        price: double.parse(_priceController.text),
        quantityInStock: int.parse(_quantityController.text),
        minimumStock: _minimumStockController.text.isEmpty 
            ? null : int.parse(_minimumStockController.text),
        batchNumber: _batchNumberController.text.trim().isEmpty 
            ? null : _batchNumberController.text.trim(),
        expiryDate: _expiryDate,
        category: _categoryController.text.trim().isEmpty 
            ? null : _categoryController.text.trim(),
        storageCondition: _storageConditionController.text.trim().isEmpty 
            ? null : _storageConditionController.text.trim(),
        prescriptionRequired: _prescriptionRequired,
      );
      
      bool success;
      if (isEditing) {
        success = await medicineViewModel.updateMedicine(
          widget.medicine!.id!,
          medicine,
        );
      } else {
        success = await medicineViewModel.createMedicine(medicine);
      }
      
      if (success && mounted) {
        Fluttertoast.showToast(
          msg: isEditing ? 'Cập nhật thành công!' : 'Thêm thuốc thành công!',
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: medicineViewModel.errorMessage,
          backgroundColor: Colors.red,
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          isEditing ? 'Sửa Thuốc' : 'Thêm Thuốc Mới',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin cơ bản',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Medicine name
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('Tên thuốc *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên thuốc';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Generic name
              TextFormField(
                controller: _genericNameController,
                decoration: _buildInputDecoration('Tên gốc'),
              ),
              const SizedBox(height: 16),
              
              // Code
              TextFormField(
                controller: _codeController,
                decoration: _buildInputDecoration('Mã thuốc *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã thuốc';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Manufacturer
              TextFormField(
                controller: _manufacturerController,
                decoration: _buildInputDecoration('Nhà sản xuất *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nhà sản xuất';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Category
              TextFormField(
                controller: _categoryController,
                decoration: _buildInputDecoration('Danh mục'),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Thông tin kho',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Price and Unit
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration('Giá bán (VNĐ) *'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập giá';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Giá không hợp lệ';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: _buildInputDecoration('Đơn vị'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Quantity and Minimum stock
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration('Số lượng *'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số lượng';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Số lượng không hợp lệ';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _minimumStockController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration('Tồn kho tối thiểu'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Batch number
              TextFormField(
                controller: _batchNumberController,
                decoration: _buildInputDecoration('Số lô'),
              ),
              const SizedBox(height: 16),
              
              // Expiry date
              InkWell(
                onTap: _selectExpiryDate,
                child: InputDecorator(
                  decoration: _buildInputDecoration('Ngày hết hạn'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _expiryDate != null
                            ? '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
                            : 'Chọn ngày hết hạn',
                        style: TextStyle(
                          color: _expiryDate != null
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Thông tin bổ sung',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Storage condition
              TextFormField(
                controller: _storageConditionController,
                decoration: _buildInputDecoration('Điều kiện bảo quản'),
              ),
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: _buildInputDecoration('Mô tả'),
              ),
              const SizedBox(height: 16),
              
              // Prescription required
              CheckboxListTile(
                title: const Text('Cần kê đơn'),
                value: _prescriptionRequired,
                onChanged: (value) {
                  setState(() {
                    _prescriptionRequired = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 32),
              
              // Save button
              Consumer<MedicineViewModel>(
                builder: (context, medicineViewModel, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: medicineViewModel.isLoading ? null : _saveMedicine,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: medicineViewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              isEditing ? 'Cập Nhật' : 'Thêm Thuốc',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}