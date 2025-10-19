# Pharmacy Management Backend - Spring Boot

## Yêu cầu hệ thống
- **Java 21** (LTS)
- Maven 3.9+
- PostgreSQL 12+

## Cài đặt Java 21

### Windows:
1. Download Java 21 từ: https://www.oracle.com/java/technologies/downloads/#java21
2. Chạy installer và follow hướng dẫn
3. Set JAVA_HOME environment variable:
   ```
   JAVA_HOME=C:\Program Files\Java\jdk-21
   Path=%JAVA_HOME%\bin
   ```

### macOS:
```bash
# Cài qua Homebrew
brew install openjdk@21

# Hoặc download từ Oracle và cài đặt
```

### Linux:
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-21-jdk

# RHEL/CentOS
sudo yum install java-21-openjdk-devel
```

## Kiểm tra Java version:
```bash
java --version
# Output: openjdk 21.0.x
```

## Build và chạy project:

### Sử dụng Maven Wrapper (Khuyến nghị):
```bash
# Windows
./mvnw.cmd clean install
./mvnw.cmd spring-boot:run

# macOS/Linux
./mvnw clean install
./mvnw spring-boot:run
```

### Sử dụng Maven global:
```bash
mvn clean install
mvn spring-boot:run
```

## Cấu hình Database:
Sửa file `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/pharmacy_db
spring.datasource.username=pharmacy_user
spring.datasource.password=pharmacy_password
```

## API Endpoints:
- Base URL: `http://localhost:8080/api`
- Swagger UI: `http://localhost:8080/swagger-ui.html` (nếu có cấu hình)

## Các tính năng Java 21 được sử dụng:
- Virtual Threads (Project Loom)
- Pattern Matching for switch
- Record Patterns
- Sequenced Collections

## Troubleshooting:

### Lỗi: "Java version not compatible"
- Kiểm tra Java version: `java --version`
- Đảm bảo đang dùng Java 21
- Update IntelliJ/Eclipse để support Java 21

### Lỗi: "Cannot find symbol"
- Clear cache: `mvn clean`
- Rebuild: `mvn install`

## Environment Variables:
```bash
export JAVA_HOME=/path/to/java21
export PATH=$JAVA_HOME/bin:$PATH
```