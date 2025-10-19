# 📚 HƯỚNG DẪN THIẾT LẬP HỆ THỐNG QUẢN LÝ KHO DƯỢC PHẨM

## 📋 MỤC LỤC
1. [Tổng quan kiến trúc](#tổng-quan-kiến-trúc)
2. [Cài đặt Backend Spring Boot](#cài-đặt-backend-spring-boot)
3. [Cài đặt Flutter Frontend](#cài-đặt-flutter-frontend)
4. [Cấu trúc dự án](#cấu-trúc-dự-án)
5. [Hướng dẫn chạy ứng dụng](#hướng-dẫn-chạy-ứng-dụng)

## 🏗️ TỔNG QUAN KIẾN TRÚC

### Backend (Spring Boot)
- **Framework**: Spring Boot 3.1.5
- **Database**: PostgreSQL
- **Authentication**: JWT Token
- **Security**: Spring Security với role-based access control
- **API**: RESTful API

### Frontend (Flutter)
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: Provider
- **HTTP Client**: Dio với Interceptors
- **Local Storage**: Shared Preferences

## 🚀 CÀI ĐẶT BACKEND SPRING BOOT

### 1. Yêu cầu hệ thống
- Java JDK 17+
- Maven 3.6+
- PostgreSQL 12+
- IntelliJ IDEA (khuyến nghị)

### 2. Cấu hình Database PostgreSQL

#### Tạo database:
```sql
CREATE DATABASE pharmacy_db;
CREATE USER pharmacy_user WITH PASSWORD 'pharmacy_password';
GRANT ALL PRIVILEGES ON DATABASE pharmacy_db TO pharmacy_user;
```

### 3. Cấu hình application.properties
File: `backend/pharmacy-management/src/main/resources/application.properties`

```properties
# Thay đổi thông tin database theo môi trường của bạn
spring.datasource.url=jdbc:postgresql://localhost:5432/pharmacy_db
spring.datasource.username=pharmacy_user
spring.datasource.password=pharmacy_password
```

### 4. Chạy Backend

#### Sử dụng Maven:
```bash
cd backend/pharmacy-management
mvn clean install
mvn spring-boot:run
```

#### Sử dụng IntelliJ:
1. Mở project trong IntelliJ
2. Chạy file `PharmacyManagementApplication.java`

Backend sẽ chạy tại: `http://localhost:8080/api`

## 📱 CÀI ĐẶT FLUTTER FRONTEND

### 1. Yêu cầu hệ thống
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio hoặc VS Code
- Android Emulator hoặc thiết bị thật

### 2. Cài đặt dependencies

```bash
cd /home/user/webapp
flutter pub get
```

### 3. Cấu hình API endpoint

File: `lib/core/constants/api_constants.dart`

```dart
// Thay đổi baseUrl theo IP của máy chủ backend
// Nếu dùng emulator Android: http://10.0.2.2:8080/api
// Nếu dùng thiết bị thật: http://[IP_MAY_CHU]:8080/api
static const String baseUrl = 'http://localhost:8080/api';
```

### 4. Chạy Flutter app

```bash
# Kiểm tra devices
flutter devices

# Chạy ứng dụng
flutter run

# Hoặc chỉ định device
flutter run -d <device_id>
```

## 📂 CẤU TRÚC DỰ ÁN

### Backend Spring Boot
```
backend/pharmacy-management/
├── src/main/java/com/pharmacy/management/
│   ├── config/           # Cấu hình (Security, CORS)
│   ├── controller/       # REST Controllers
│   ├── dto/             # Data Transfer Objects
│   ├── entity/          # JPA Entities
│   ├── exception/       # Custom Exceptions
│   ├── repository/      # JPA Repositories
│   ├── security/        # Security & JWT
│   └── service/         # Business Logic
└── src/main/resources/
    └── application.properties
```

### Flutter Frontend (MVVM)
```
lib/
├── core/
│   ├── constants/       # Hằng số (API, Colors)
│   ├── network/         # Dio Client config
│   └── utils/          # Utilities
├── data/
│   ├── models/         # Data Models
│   ├── repositories/   # API Repositories
│   └── datasources/    # Local/Remote sources
├── presentation/
│   ├── views/          # UI Screens
│   ├── viewmodels/     # ViewModels (Provider)
│   └── widgets/        # Reusable Widgets
└── main.dart
```

## 🔑 CHỨC NĂNG CHÍNH

### 1. Authentication (Xác thực)
- **Đăng ký**: POST `/api/auth/register`
- **Đăng nhập**: POST `/api/auth/login`
- **Đăng xuất**: POST `/api/auth/logout`

### 2. Quản lý thuốc (Medicine Management)
- **Danh sách thuốc**: GET `/api/medicines`
- **Tìm kiếm**: GET `/api/medicines/search?keyword=`
- **Thêm thuốc**: POST `/api/medicines` (ADMIN/MANAGER)
- **Sửa thuốc**: PUT `/api/medicines/{id}` (ADMIN/MANAGER)
- **Xóa thuốc**: DELETE `/api/medicines/{id}` (ADMIN)
- **Thuốc sắp hết hạn**: GET `/api/medicines/expiring`
- **Thuốc sắp hết hàng**: GET `/api/medicines/low-stock`

### 3. Phân quyền (Roles)
- **ADMIN**: Toàn quyền
- **MANAGER**: Thêm, sửa thuốc
- **STAFF**: Chỉ xem

## 🧪 TEST API VỚI POSTMAN

### 1. Đăng ký user mới
```http
POST http://localhost:8080/api/auth/register
Content-Type: application/json

{
    "username": "admin",
    "password": "admin123",
    "email": "admin@pharmacy.com",
    "fullName": "Nguyễn Văn Admin",
    "phoneNumber": "0901234567"
}
```

### 2. Đăng nhập
```http
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
    "username": "admin",
    "password": "admin123"
}
```

Response trả về JWT token:
```json
{
    "token": "eyJhbGciOiJIUzUxMiJ9...",
    "type": "Bearer",
    "id": 1,
    "username": "admin",
    "email": "admin@pharmacy.com",
    "role": "ROLE_STAFF"
}
```

### 3. Sử dụng token để gọi API
```http
GET http://localhost:8080/api/medicines
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9...
```

## 📋 BƯỚC TIẾP THEO

### Backend:
1. ✅ Cấu trúc cơ bản đã hoàn thành
2. ⏳ Cần thêm: Inventory tracking, Reports, Statistics
3. ⏳ Cần thêm: Audit logs, Activity tracking

### Flutter:
1. ✅ Cấu trúc MVVM với Provider
2. ⏳ Cần tạo: Login/Register screens
3. ⏳ Cần tạo: Medicine list/detail screens
4. ⏳ Cần tạo: Add/Edit medicine forms
5. ⏳ Cần tạo: Dashboard với statistics

## 🛠️ TROUBLESHOOTING

### Lỗi kết nối database:
- Kiểm tra PostgreSQL đang chạy
- Kiểm tra username/password trong application.properties
- Kiểm tra firewall/port 5432

### Lỗi CORS:
- Đảm bảo frontend URL được thêm vào allowed-origins
- Kiểm tra file CorsConfig.java

### Flutter không kết nối được API:
- Android emulator: dùng `http://10.0.2.2:8080/api`
- Thiết bị thật: dùng IP máy chủ thay vì localhost
- Kiểm tra firewall cho phép port 8080

## 📞 LIÊN HỆ HỖ TRỢ

Nếu gặp vấn đề khi setup, vui lòng:
1. Kiểm tra logs trong console
2. Đảm bảo đã cài đặt đủ dependencies
3. Xem lại các bước cấu hình

---

**Phát triển bởi**: Pharmacy Management Team
**Version**: 1.0.0
**Ngày cập nhật**: 2024