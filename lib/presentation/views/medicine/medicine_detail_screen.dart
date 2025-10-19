import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/medicine_model.dart';

class MedicineDetailScreen extends StatelessWidget {
  final MedicineModel medicine;

  const MedicineDetailScreen({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          medicine.name,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // TODO: Delete medicine
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Card
            _buildCard(
              title: 'Thông tin cơ bản',
              icon: Icons.info,
              children: [
                _buildInfoRow('Mã thuốc', medicine.code),
                _buildInfoRow('Tên thuốc', medicine.name),
                if (medicine.genericName != null)
                  _buildInfoRow('Tên gốc', medicine.genericName!),
                _buildInfoRow('Nhà sản xuất', medicine.manufacturer),
                if (medicine.category != null)
                  _buildInfoRow('Danh mục', medicine.category!),
                _buildInfoRow(
                  'Cần kê đơn',
                  medicine.prescriptionRequired ? 'Có' : 'Không',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Inventory Information Card
            _buildCard(
              title: 'Thông tin kho',
              icon: Icons.inventory,
              children: [
                _buildInfoRow(
                  'Số lượng tồn',
                  '${medicine.quantityInStock} ${medicine.unitOfMeasure ?? ''}',
                  valueColor: medicine.quantityInStock <= (medicine.minimumStock ?? 10)
                      ? AppColors.error
                      : AppColors.success,
                ),
                if (medicine.minimumStock != null)
                  _buildInfoRow('Tồn kho tối thiểu', '${medicine.minimumStock}'),
                _buildInfoRow(
                  'Giá bán',
                  '${NumberFormat('#,###').format(medicine.price)}đ',
                  valueColor: AppColors.primary,
                ),
                if (medicine.batchNumber != null)
                  _buildInfoRow('Số lô', medicine.batchNumber!),
                if (medicine.expiryDate != null)
                  _buildInfoRow(
                    'Ngày hết hạn',
                    DateFormat('dd/MM/yyyy').format(medicine.expiryDate!),
                    valueColor: medicine.expiryDate!.difference(DateTime.now()).inDays <= 30
                        ? AppColors.warning
                        : null,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Additional Information Card
            if (medicine.description != null || medicine.storageCondition != null)
              _buildCard(
                title: 'Thông tin bổ sung',
                icon: Icons.description,
                children: [
                  if (medicine.description != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mô tả:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            medicine.description!,
                            style: const TextStyle(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  if (medicine.storageCondition != null)
                    _buildInfoRow('Điều kiện bảo quản', medicine.storageCondition!),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}