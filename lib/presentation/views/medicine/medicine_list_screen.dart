import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/medicine_model.dart';
import '../../viewmodels/medicine_viewmodel.dart';
import 'medicine_detail_screen.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({Key? key}) : super(key: key);

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final medicineViewModel = Provider.of<MedicineViewModel>(
        context,
        listen: false,
      );
      medicineViewModel.loadMedicinesPaginated();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final medicineViewModel = Provider.of<MedicineViewModel>(
          context,
          listen: false,
        );
        if (medicineViewModel.hasNextPage) {
          medicineViewModel.loadMedicinesPaginated(nextPage: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm thuốc...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        final medicineViewModel =
                            Provider.of<MedicineViewModel>(
                              context,
                              listen: false,
                            );
                        medicineViewModel.clearSearch();
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              final medicineViewModel = Provider.of<MedicineViewModel>(
                context,
                listen: false,
              );
              if (value.isNotEmpty) {
                medicineViewModel.searchMedicines(value);
              } else {
                medicineViewModel.clearSearch();
              }
            },
          ),
        ),

        // Medicine list
        Expanded(
          child: Consumer<MedicineViewModel>(
            builder: (context, medicineViewModel, _) {
              if (medicineViewModel.isLoading &&
                  medicineViewModel.medicines.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final medicines = medicineViewModel.searchResults.isNotEmpty
                  ? medicineViewModel.searchResults
                  : medicineViewModel.medicines;

              if (medicines.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.medical_services_outlined,
                        size: 100,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Không có thuốc nào',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await medicineViewModel.loadMedicinesPaginated();
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      medicines.length +
                      (medicineViewModel.hasNextPage ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == medicines.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final medicine = medicines[index];
                    return _buildMedicineCard(medicine);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineCard(MedicineModel medicine) {
    final isLowStock =
        medicine.quantityInStock <= (medicine.minimumStock ?? 10);
    final isExpiringSoon =
        medicine.expiryDate != null &&
        medicine.expiryDate!.difference(DateTime.now()).inDays <= 30;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MedicineDetailScreen(medicine: medicine),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mã: ${medicine.code}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (medicine.genericName != null)
                          Text(
                            medicine.genericName!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${NumberFormat('#,###').format(medicine.price)}đ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isLowStock
                              ? AppColors.error.withValues(alpha: 0.1)
                              : AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Tồn: ${medicine.quantityInStock}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isLowStock
                                ? AppColors.error
                                : AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildChip(medicine.manufacturer, Icons.business),
                  if (medicine.category != null)
                    _buildChip(medicine.category!, Icons.category),
                  if (isExpiringSoon)
                    _buildChip(
                      'Sắp hết hạn',
                      Icons.warning,
                      color: AppColors.warning,
                    ),
                  if (medicine.prescriptionRequired)
                    _buildChip(
                      'Cần kê đơn',
                      Icons.assignment,
                      color: AppColors.error,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? AppColors.primary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color ?? AppColors.primary),
          ),
        ],
      ),
    );
  }
}
