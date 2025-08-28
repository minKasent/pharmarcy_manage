import 'package:flutter/material.dart';
import 'package:pharma_management/core/component/app_text.dart';
import 'package:pharma_management/core/component/app_text_style.dart';
import 'package:pharma_management/core/constant/app_color_path.dart';

class Product {
  final String name;
  final String image;
  final double price;

  Product({required this.name, required this.image, required this.price});
}

class ProductGridScreen extends StatelessWidget {
  // List Product
  final List<Product> products = List.generate(
    51,
        (index) => Product(
      name: "Product  ${index + 1}",
      image: "assets/images/image_medic_product_${(index % 6) + 1}.png",
      // giả sử có 5 ảnh: image_medic_product_1.png ... image_medic_product_5.png
      price: 10 + (index % 5) * 2.5,
    ),
  );

  ProductGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true, // bỏ padding mặc định
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 7, 12, 12),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // mỗi hàng 3 sản phẩm
            crossAxisSpacing: 12, // khoảng cách ngang giữa các card
            mainAxisSpacing: 12, // dọc
            childAspectRatio: 0.9, // tỷ lệ chiều rộng / chiều cao card
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(product);
          },
        ),
      ),
    );
  }

  // Widget hiển thị card sản phẩm
  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorPath.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColorPath.black.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ảnh sản phẩm
          SizedBox(
            height: 60,
            child: Image.asset(
              product.image,
              fit: BoxFit.contain, // giữ nguyên tỉ lệ ảnh
            ),
          ),
          const SizedBox(height: 8),
          // tên sản phẩm
          AppText(
            content:  product.name,
            style: AppTextStyle.text12Regular,
          ),
          const SizedBox(height: 4),
          // giá sản phẩm
          AppText(
            content: "\$ ${product.price}",
            style: AppTextStyle.text12Regular,
          ),
        ],
      ),
    );
  }
}
