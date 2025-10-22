import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/dio_client.dart';
import 'core/constants/app_colors.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/medicine_viewmodel.dart';
import 'presentation/views/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dio client
  await DioClient().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => MedicineViewModel()),
      ],
      child: MaterialApp(
        title: 'Quản Lý Nhà Thuốc',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
