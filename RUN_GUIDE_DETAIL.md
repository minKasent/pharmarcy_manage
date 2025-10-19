# 🚀 HƯỚNG DẪN CHẠY DỰ ÁN QUẢN LÝ NHÀ THUỐC - CHI TIẾT TỪNG BƯỚC

## 📌 YÊU CẦU CÀI ĐẶT TRƯỚC

### 1. Cài đặt các phần mềm cần thiết:
- ✅ **Java JDK 21**: https://www.oracle.com/java/technologies/downloads/#java21
- ✅ **Android Studio**: https://developer.android.com/studio
- ✅ **IntelliJ IDEA**: https://www.jetbrains.com/idea/download/
- ✅ **PostgreSQL**: https://www.postgresql.org/download/
- ✅ **Git**: https://git-scm.com/downloads
- ✅ **Flutter SDK**: https://docs.flutter.dev/get-started/install
- ✅ **Postman** (để test API): https://www.postman.com/downloads/

---

## 🗄️ **PHẦN 1: CÀI ĐẶT VÀ THIẾT LẬP DATABASE POSTGRESQL**

### Cách 1: Cài PostgreSQL trên Windows

#### Bước 1.1: Download và cài đặt PostgreSQL
1. Vào link: https://www.postgresql.org/download/windows/
2. Download **PostgreSQL Installer** phiên bản 15 hoặc mới hơn
3. Chạy file installer và làm theo các bước:
   - Chọn thư mục cài đặt (mặc định C:\Program Files\PostgreSQL\15)
   - **GHI NHỚ PASSWORD** cho user `postgres` (ví dụ: `postgres123`)
   - Port mặc định: `5432` (giữ nguyên)
   - Locale: Default
   - Nhấn Next và Install

#### Bước 1.2: Mở pgAdmin 4 (cài kèm với PostgreSQL)
1. Mở **pgAdmin 4** từ Start Menu
2. Nhập password master (tạo lần đầu mở)
3. Click vào **Servers** > **PostgreSQL 15**
4. Nhập password của user `postgres` (đã tạo ở bước 1.1)

#### Bước 1.3: Tạo Database và User
1. **Click chuột phải vào "Databases"** > **Create** > **Database**
   - Database name: `pharmacy_db`
   - Owner: postgres
   - Click **Save**

2. **Tạo user mới (không bắt buộc, có thể dùng postgres)**:
   - Click chuột phải vào **Login/Group Roles** > **Create** > **Login/Group Role**
   - Tab General:
     - Name: `pharmacy_user`
   - Tab Definition:
     - Password: `pharmacy_password`
   - Tab Privileges:
     - Can login?: Yes
     - Superuser?: Yes (hoặc No nếu muốn giới hạn quyền)
   - Click **Save**

3. **Gán quyền cho user (nếu tạo user mới)**:
   - Click chuột phải vào database `pharmacy_db`
   - Chọn **Properties** > Tab **Security**
   - Click nút **+** để thêm
   - Grantee: `pharmacy_user`
   - Privileges: Chọn **ALL**
   - Click **Save**

### Cách 2: Cài PostgreSQL trên macOS

```bash
# Cài Homebrew nếu chưa có
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Cài PostgreSQL
brew install postgresql@15
brew services start postgresql@15

# Tạo database
psql postgres
CREATE DATABASE pharmacy_db;
CREATE USER pharmacy_user WITH PASSWORD 'pharmacy_password';
GRANT ALL PRIVILEGES ON DATABASE pharmacy_db TO pharmacy_user;
\q
```

### Cách 3: Sử dụng Docker (Đơn giản nhất)

#### Bước 1: Cài Docker Desktop
- Windows/Mac: https://www.docker.com/products/docker-desktop/
- Cài đặt và khởi động Docker Desktop

#### Bước 2: Chạy PostgreSQL bằng Docker
1. Mở **Command Prompt** hoặc **Terminal**
2. Di chuyển đến thư mục project:
```bash
cd path/to/your/project
```

3. Chạy Docker Compose (file đã có sẵn trong project):
```bash
docker-compose up -d
```

4. Database sẽ tự động được tạo với thông tin:
   - Host: localhost
   - Port: 5432
   - Database: pharmacy_db
   - Username: pharmacy_user
   - Password: pharmacy_password

5. Truy cập pgAdmin tại: http://localhost:5050
   - Email: admin@pharmacy.com
   - Password: admin123

---

## ☕ **PHẦN 2: CHẠY BACKEND SPRING BOOT TRONG INTELLIJ**

### Bước 2.1: Mở project trong IntelliJ IDEA

1. Mở **IntelliJ IDEA**
2. Chọn **Open** > Navigate đến thư mục `backend/pharmacy-management`
3. Chọn folder và click **OK**
4. IntelliJ sẽ tự động nhận diện đây là Maven project

### Bước 2.2: Cấu hình database connection

1. Mở file: `src/main/resources/application.properties`
2. Sửa thông tin database theo cách bạn cài:

**Nếu dùng PostgreSQL cài trực tiếp với user postgres:**
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/pharmacy_db
spring.datasource.username=postgres
spring.datasource.password=postgres123  # password bạn đã đặt khi cài
```

**Nếu dùng Docker hoặc tạo user pharmacy_user:**
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/pharmacy_db
spring.datasource.username=pharmacy_user
spring.datasource.password=pharmacy_password
```

### Bước 2.3: Build và chạy project

#### Cách 1: Dùng Maven trong IntelliJ
1. Mở tab **Maven** ở bên phải IntelliJ
2. Expand **pharmacy-management** > **Lifecycle**
3. Double-click **clean** (chờ xong)
4. Double-click **install** (chờ download dependencies)

#### Cách 2: Dùng Terminal trong IntelliJ
1. Mở Terminal trong IntelliJ (View > Tool Windows > Terminal)
2. Chạy lệnh:
```bash
mvn clean install
```

### Bước 2.4: Chạy ứng dụng Spring Boot

1. Tìm file `PharmacyManagementApplication.java` trong:
   `src/main/java/com/pharmacy/management/`
2. Click chuột phải > **Run 'PharmacyManagementApplication'**
3. Hoặc click nút ▶️ màu xanh bên cạnh class name

4. **Kiểm tra console**, nếu thành công sẽ thấy:
```
Started PharmacyManagementApplication in X.XXX seconds
Tomcat started on port(s): 8080
```

5. **Test API**: Mở browser, truy cập:
   - http://localhost:8080/api

### Bước 2.5: Tạo tài khoản Admin bằng Postman

1. Mở **Postman**
2. Tạo request mới:
   - Method: **POST**
   - URL: `http://localhost:8080/api/auth/register`
   - Body: Chọn **raw** và **JSON**

3. Paste JSON sau:
```json
{
    "username": "admin",
    "password": "admin123",
    "email": "admin@pharmacy.com",
    "fullName": "Quản Trị Viên",
    "phoneNumber": "0901234567"
}
```

4. Click **Send**
5. Nếu thành công, response sẽ có message "Đăng ký thành công!"

---

## 📱 **PHẦN 3: CHẠY FLUTTER TRONG ANDROID STUDIO**

### Bước 3.1: Cài Flutter Plugin trong Android Studio

1. Mở **Android Studio**
2. Vào **File** > **Settings** (Windows) hoặc **Preferences** (macOS)
3. Chọn **Plugins** > Search "Flutter"
4. Install **Flutter** plugin (tự động cài Dart plugin)
5. Restart Android Studio

### Bước 3.2: Thiết lập Flutter SDK

1. Nếu chưa cài Flutter SDK:
   - Download: https://docs.flutter.dev/get-started/install
   - Giải nén vào folder (ví dụ: `C:\flutter` hoặc `~/flutter`)
   
2. Trong Android Studio:
   - **File** > **Settings** > **Languages & Frameworks** > **Flutter**
   - Flutter SDK path: Browse đến thư mục flutter
   - Click **Apply** > **OK**

### Bước 3.3: Mở Flutter project

1. **File** > **Open**
2. Navigate đến thư mục gốc project (có file `pubspec.yaml`)
3. Click **OK**
4. Android Studio sẽ tự động detect Flutter project

### Bước 3.4: Cấu hình API endpoint

1. Mở file: `lib/core/constants/api_constants.dart`
2. Sửa `baseUrl` theo môi trường của bạn:

**Nếu dùng Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

**Nếu dùng thiết bị thật (điện thoại):**
```dart
// Thay YOUR_COMPUTER_IP bằng IP máy tính của bạn
static const String baseUrl = 'http://192.168.1.100:8080/api';
```

**Cách tìm IP máy tính:**
- Windows: Mở cmd > gõ `ipconfig` > tìm IPv4 Address
- macOS: Terminal > gõ `ifconfig` > tìm inet của en0

### Bước 3.5: Cài dependencies và chạy app

1. **Mở Terminal trong Android Studio** (View > Tool Windows > Terminal)

2. **Cài đặt packages:**
```bash
flutter pub get
```

3. **Kiểm tra devices:**
```bash
flutter devices
```

### Bước 3.6: Tạo và chạy Android Emulator

1. **Mở AVD Manager**: Tools > AVD Manager
2. Click **Create Virtual Device**
3. Chọn Phone > **Pixel 4** (hoặc device khác) > Next
4. Chọn System Image: **API 33** (Android 13) > Next
5. Đặt tên AVD > Finish
6. Click nút ▶️ để start emulator

### Bước 3.7: Chạy Flutter app

#### Cách 1: Dùng nút Run
1. Chọn device/emulator từ dropdown trên toolbar
2. Click nút ▶️ **Run** (hoặc Shift+F10)

#### Cách 2: Dùng Terminal
```bash
flutter run
```

### Bước 3.8: Test ứng dụng

1. **Màn hình đăng nhập** sẽ hiện ra
2. Click "Đăng ký ngay" để tạo tài khoản
3. Điền thông tin và đăng ký
4. Đăng nhập với tài khoản vừa tạo
5. Khám phá các chức năng:
   - Dashboard
   - Danh sách thuốc
   - Thêm thuốc mới
   - Xem chi tiết thuốc

---

## 🔧 **KHẮC PHỤC LỖI THƯỜNG GẶP**

### Lỗi 1: Không kết nối được database
```
org.postgresql.util.PSQLException: Connection refused
```
**Giải pháp:**
- Kiểm tra PostgreSQL đang chạy
- Kiểm tra port 5432 không bị chiếm
- Kiểm tra username/password trong application.properties

### Lỗi 2: Flutter không kết nối được API
```
SocketException: Connection refused
```
**Giải pháp:**
- Đảm bảo backend Spring Boot đang chạy
- Kiểm tra baseUrl trong api_constants.dart
- Tắt firewall hoặc cho phép port 8080

### Lỗi 3: Flutter pub get failed
**Giải pháp:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Lỗi 4: Build failed trong Android Studio
**Giải pháp:**
1. File > Invalidate Caches > Invalidate and Restart
2. Build > Clean Project
3. Build > Rebuild Project

---

## 📸 **SCREENSHOTS HƯỚNG DẪN**

### Database trong pgAdmin:
1. Servers > PostgreSQL > Databases > pharmacy_db
2. Tables sẽ tự động được tạo khi chạy Spring Boot

### Backend trong IntelliJ:
1. Project structure: backend/pharmacy-management
2. Run configuration: PharmacyManagementApplication

### Flutter trong Android Studio:
1. Project structure hiển thị lib folder
2. Device selector và Run button trên toolbar

---

## 💡 **TIPS QUAN TRỌNG**

1. **Luôn chạy backend trước khi chạy Flutter app**
2. **Database phải running trước khi start backend**
3. **Dùng Hot Reload (⚡) trong Flutter để test nhanh**
4. **Xem logs trong console để debug**
5. **Test API với Postman trước khi test trên app**

---

## 📞 **HỖ TRỢ**

Nếu gặp lỗi:
1. Kiểm tra console logs
2. Google error message
3. Kiểm tra lại từng bước trong hướng dẫn
4. Đảm bảo versions phần mềm phù hợp

**Versions khuyến nghị:**
- Java: 21
- Flutter: 3.0+
- PostgreSQL: 12+
- Android Studio: Latest
- IntelliJ IDEA: 2023.x

---

**Chúc bạn chạy thành công! 🎉**