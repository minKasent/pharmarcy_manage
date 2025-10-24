// class ApiConstants {
//   // 10.0.2.2 là địa chỉ để Android emulator truy cập localhost của máy host
//   // Nếu chạy trên web/Windows, đổi lại thành 'http://localhost:8080/api'
//   static const String baseUrl = 'http://10.0.2.2:8080/api';
//   static const String loginEndpoint = '/auth/login';
//   static const String registerEndpoint = '/auth/register';
//   static const String logoutEndpoint = '/auth/logout';
//   static const String changePasswordEndpoint = '/auth/change-password';
//   static const String medicinesEndpoint = '/medicines';

//   static const Duration connectTimeout = Duration(seconds: 30);
//   static const Duration receiveTimeout = Duration(seconds: 30);
// }

class ApiConstants {
  // 10.0.2.2 là địa chỉ để Android emulator truy cập localhost của máy host
  // Nếu chạy trên web/Windows, đổi lại thành 'http://localhost:8080/api'
  static const String baseUrl = 'http://192.168.2.36:8080/api';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String changePasswordEndpoint = '/auth/change-password';
  static const String medicinesEndpoint = '/medicines';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
