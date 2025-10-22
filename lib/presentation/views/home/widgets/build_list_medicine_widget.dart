import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pharmar_management/core/components/app_text.dart';
import 'package:pharmar_management/core/components/app_text_style.dart';
import 'package:pharmar_management/core/constants/app_color_path.dart';
import 'package:pharmar_management/data/models/medicine_model.dart';
import 'package:pharmar_management/presentation/viewmodels/medicine_viewmodel.dart';
import 'package:pharmar_management/presentation/viewmodels/base_viewmodel.dart';

class ProductGridScreen extends StatefulWidget {
  const ProductGridScreen({super.key});

  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  @override
  void initState() {
    super.initState();
    // Load dữ liệu thuốc từ API khi widget được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final medicineViewModel = Provider.of<MedicineViewModel>(
        context,
        listen: false,
      );
      medicineViewModel.loadMedicines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MedicineViewModel>(
        builder: (context, medicineViewModel, _) {
          // Hiển thị loading khi đang tải dữ liệu
          if (medicineViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Hiển thị lỗi nếu có
          if (medicineViewModel.state == ViewState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  AppText(
                    content: 'Lỗi: ${medicineViewModel.errorMessage}',
                    style: AppTextStyle.text12Regular.copyWith(
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      medicineViewModel.loadMedicines();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final medicines = medicineViewModel.medicines;

          // Hiển thị thông báo nếu không có dữ liệu
          if (medicines.isEmpty) {
            return Center(
              child: AppText(
                content: 'Chưa có sản phẩm nào',
                style: AppTextStyle.text12Regular,
              ),
            );
          }

          // Hiển thị danh sách thuốc
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 7, 12, 12),
              itemCount: medicines.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // mỗi hàng 3 sản phẩm
                crossAxisSpacing: 12, // khoảng cách ngang giữa các card
                mainAxisSpacing: 12, // dọc
                childAspectRatio: 0.9, // tỷ lệ chiều rộng / chiều cao card
              ),
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return _buildProductCard(medicine);
              },
            ),
          );
        },
      ),
    );
  }

  // Widget hiển thị card sản phẩm
  Widget _buildProductCard(MedicineModel medicine) {
    // Lấy ảnh mặc định từ assets dựa vào index
    final defaultImages = [
      "assets/images/image_medic_product_1.png",
      "assets/images/image_medic_product_2.png",
      "assets/images/image_medic_product_3.png",
      "assets/images/image_medic_product_4.png",
      "assets/images/image_medic_product_5.png",
      "assets/images/image_medic_product_6.png",
    ];

    final imageIndex = (medicine.id ?? 0) % defaultImages.length;
    final defaultImage = defaultImages[imageIndex];

    return Container(
      decoration: BoxDecoration(
        color: AppColorPath.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColorPath.black.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ảnh sản phẩm
          SizedBox(
            height: 60,
            child: medicine.imageUrl != null
                ? Image.network(
                    medicine.imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Nếu không load được ảnh từ URL, hiển thị ảnh mặc định
                      return Image.asset(defaultImage, fit: BoxFit.contain);
                    },
                  )
                : Image.asset(defaultImage, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          // tên sản phẩm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AppText(
              content: medicine.name,
              style: AppTextStyle.text12Regular,
            ),
          ),
          const SizedBox(height: 4),
          // giá sản phẩm
          AppText(
            content: "${medicine.price.toStringAsFixed(0)} đ",
            style: AppTextStyle.text12Regular.copyWith(
              color: AppColorPath.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
