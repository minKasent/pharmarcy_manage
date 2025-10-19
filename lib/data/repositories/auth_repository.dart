import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final DioClient _dioClient = DioClient();
  
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'username': username,
          'password': password,
        },
      );
      
      final userData = response.data;
      final user = UserModel.fromJson(userData);
      
      // Lưu token
      if (userData['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', userData['token']);
        await prefs.setString('user_data', user.toJson().toString());
      }
      
      return user;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<UserModel> register({
    required String username,
    required String password,
    required String email,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.registerEndpoint,
        data: {
          'username': username,
          'password': password,
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
        },
      );
      
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<void> logout() async {
    try {
      await _dioClient.dio.post(ApiConstants.logoutEndpoint);
      
      // Xóa token và user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) return null;
      
      // TODO: Implement get current user endpoint if needed
      return null;
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }
  
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối timeout. Vui lòng thử lại.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        
        if (statusCode == 401) {
          return data['message'] ?? 'Username hoặc password không đúng!';
        } else if (statusCode == 409) {
          return data['message'] ?? 'Tài khoản đã tồn tại!';
        } else if (statusCode == 400) {
          if (data['errors'] != null) {
            return data['errors'].values.first.toString();
          }
          return data['message'] ?? 'Dữ liệu không hợp lệ!';
        }
        
        return data['message'] ?? 'Có lỗi xảy ra!';
      case DioExceptionType.cancel:
        return 'Request đã bị hủy';
      case DioExceptionType.connectionError:
        return 'Không thể kết nối đến server';
      default:
        return 'Có lỗi xảy ra. Vui lòng thử lại!';
    }
  }
}