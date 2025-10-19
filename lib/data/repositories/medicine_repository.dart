import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/medicine_model.dart';

class MedicineRepository {
  final DioClient _dioClient = DioClient();
  
  Future<List<MedicineModel>> getAllMedicines() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.medicinesEndpoint);
      
      return (response.data as List)
          .map((json) => MedicineModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> getMedicinesPaginated({
    int page = 0,
    int size = 10,
    String sortBy = 'id',
    String sortDirection = 'DESC',
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.medicinesEndpoint}/page',
        queryParameters: {
          'page': page,
          'size': size,
          'sortBy': sortBy,
          'sortDirection': sortDirection,
        },
      );
      
      return {
        'content': (response.data['content'] as List)
            .map((json) => MedicineModel.fromJson(json))
            .toList(),
        'totalElements': response.data['totalElements'],
        'totalPages': response.data['totalPages'],
        'currentPage': response.data['number'],
      };
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<MedicineModel>> searchMedicines(String keyword) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.medicinesEndpoint}/search',
        queryParameters: {'keyword': keyword},
      );
      
      return (response.data['content'] as List)
          .map((json) => MedicineModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<MedicineModel> getMedicineById(int id) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.medicinesEndpoint}/$id',
      );
      
      return MedicineModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<MedicineModel> createMedicine(MedicineModel medicine) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.medicinesEndpoint,
        data: medicine.toJson(),
      );
      
      return MedicineModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<MedicineModel> updateMedicine(int id, MedicineModel medicine) async {
    try {
      final response = await _dioClient.dio.put(
        '${ApiConstants.medicinesEndpoint}/$id',
        data: medicine.toJson(),
      );
      
      return MedicineModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<void> deleteMedicine(int id) async {
    try {
      await _dioClient.dio.delete(
        '${ApiConstants.medicinesEndpoint}/$id',
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<MedicineModel>> getExpiringMedicines({int daysBeforeExpiry = 30}) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.medicinesEndpoint}/expiring',
        queryParameters: {'daysBeforeExpiry': daysBeforeExpiry},
      );
      
      return (response.data as List)
          .map((json) => MedicineModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<MedicineModel>> getLowStockMedicines() async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.medicinesEndpoint}/low-stock',
      );
      
      return (response.data as List)
          .map((json) => MedicineModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
        
        if (statusCode == 404) {
          return data['message'] ?? 'Không tìm thấy dữ liệu!';
        } else if (statusCode == 409) {
          return data['message'] ?? 'Dữ liệu đã tồn tại!';
        } else if (statusCode == 400) {
          if (data['errors'] != null) {
            return data['errors'].values.first.toString();
          }
          return data['message'] ?? 'Dữ liệu không hợp lệ!';
        } else if (statusCode == 403) {
          return 'Bạn không có quyền thực hiện thao tác này!';
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