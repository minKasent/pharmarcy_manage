# 📊 BÁO CÁO ĐỒ ÁN - HỆ THỐNG QUẢN LÝ NHÀ THUỐC

## 📌 PHẦN 1: GIỚI THIỆU ĐỀ TÀI

### 1.1. Tên Đề Tài
**"HỆ THỐNG QUẢN LÝ NHÀ THUỐC"**  
*(Pharmacy Management System)*

### 1.2. Nghiệp Vụ Đề Tài

Hệ thống quản lý nhà thuốc là một ứng dụng web/mobile giúp quản lý các hoạt động cơ bản của một nhà thuốc, bao gồm:

**Nghiệp vụ chính:**
1. **Quản lý người dùng**: Đăng ký, đăng nhập, xác thực, phân quyền
2. **Quản lý thuốc**: Theo dõi thông tin thuốc, tồn kho, giá cả, hạn sử dụng

**Mục đích:**
- Số hóa quy trình quản lý nhà thuốc
- Giảm sai sót trong quản lý thông tin
- Theo dõi tồn kho và cảnh báo thuốc hết hạn
- Quản lý thông tin thuốc một cách khoa học

**Đối tượng sử dụng:**
- Quản lý nhà thuốc (Admin)
- Nhân viên bán hàng (Staff)
- Dược sĩ (Pharmacist)

---

## 📱 PHẦN 2: SỐ LƯỢNG MÀN HÌNH VÀ CHỨC NĂNG

### 2.1. Tổng Quan

- **Tổng số màn hình**: 8 màn hình chính
- **Tổng số chức năng**: 9 chức năng (9 Use Cases)
- **Số module**: 2 module chính (User Management, Medicine Management)

### 2.2. Chi Tiết Từng Màn Hình

#### **MÀN HÌNH 1: LOGIN (Đăng Nhập)**

**Chức năng:**
- UC2: Đăng nhập vào hệ thống

**Các thành phần UI:**
- TextField: Username (tên đăng nhập)
- TextField: Password (mật khẩu, ẩn ký tự)
- Button: "Đăng nhập"
- Link: "Đăng ký ngay" (chuyển sang màn hình Register)
- Logo ứng dụng

**Nghiệp vụ chi tiết:**
1. User nhập username và password
2. Nhấn nút "Đăng nhập"
3. Hệ thống gửi request POST đến `/api/auth/login`
4. Backend kiểm tra username và password trong database
5. Nếu đúng: Backend tạo JWT token (Access + Refresh)
6. Frontend lưu token vào SharedPreferences
7. Chuyển sang màn hình Home

**Validation:**
- Username không được để trống
- Password không được để trống
- Hiển thị lỗi nếu username/password sai

---

#### **MÀN HÌNH 2: REGISTER (Đăng Ký)**

**Chức năng:**
- UC1: Đăng ký tài khoản mới

**Các thành phần UI:**
- TextField: Username
- TextField: Email
- TextField: Full Name (họ tên)
- TextField: Phone Number (số điện thoại)
- TextField: Password
- TextField: Confirm Password
- Button: "Đăng ký"
- Link: "Đã có tài khoản? Đăng nhập"

**Nghiệp vụ chi tiết:**
1. User điền đầy đủ thông tin
2. Nhấn nút "Đăng ký"
3. Frontend validate dữ liệu:
   - Username: 3-50 ký tự
   - Email: format đúng
   - Password: tối thiểu 6 ký tự
   - Confirm Password phải khớp với Password
4. Gửi request POST đến `/api/auth/register`
5. Backend kiểm tra username và email chưa tồn tại
6. Backend mã hóa password bằng BCrypt
7. Lưu user mới vào database
8. Trả về thông báo "Đăng ký thành công"
9. Chuyển về màn hình Login

**Validation:**
- Username: bắt buộc, 3-50 ký tự, chưa tồn tại
- Email: bắt buộc, format đúng, chưa tồn tại
- Password: bắt buộc, >= 6 ký tự
- Confirm Password: phải khớp với Password

---

#### **MÀN HÌNH 3: HOME/OVERVIEW (Trang Chủ)**

**Chức năng:**
- UC5: Xem danh sách thuốc

**Các thành phần UI:**
- AppBar: Logo, tên user, nút Profile
- Search Bar: Tìm kiếm thuốc
- Grid View: Danh sách thuốc (hiển thị dạng lưới)
  - Mỗi item gồm: Hình ảnh, Tên thuốc, Giá, Số lượng tồn
- FloatingActionButton: "+" (Thêm thuốc mới)
- Bottom Navigation Bar: Home, Profile, Logout

**Nghiệp vụ chi tiết:**
1. Khi vào màn hình, gửi GET request đến `/api/medicines`
2. Backend lấy danh sách thuốc từ database (WHERE isActive = true)
3. Trả về danh sách dưới dạng JSON
4. Frontend hiển thị danh sách dạng GridView
5. User có thể:
   - Click vào thuốc → Xem chi tiết (UC6)
   - Click nút "+" → Thêm thuốc mới (UC7)
   - Search thuốc theo tên/mã

**Dữ liệu hiển thị:**
- Tên thuốc
- Mã thuốc
- Giá bán
- Số lượng tồn kho
- Hình ảnh (nếu có)

---

#### **MÀN HÌNH 4: MEDICINE DETAIL (Chi Tiết Thuốc)**

**Chức năng:**
- UC6: Xem chi tiết thuốc
- UC8: Sửa thuốc (nếu user có quyền)
- UC9: Xóa thuốc (nếu user có quyền)

**Các thành phần UI:**
- Image: Hình ảnh thuốc lớn
- Text: Tên thuốc (name)
- Text: Mã thuốc (code)
- Text: Tên generic (genericName)
- Text: Nhà sản xuất (manufacturer)
- Text: Mô tả (description)
- Text: Đơn vị tính (unitOfMeasure)
- Text: Giá (price)
- Text: Số lượng tồn kho (quantityInStock)
- Text: Số lượng tối thiểu (minimumStock)
- Text: Số lô (batchNumber)
- Text: Ngày hết hạn (expiryDate)
- Text: Danh mục (category)
- Text: Điều kiện bảo quản (storageCondition)
- Checkbox: Cần đơn thuốc (prescriptionRequired)
- Button: "Sửa" (nếu có quyền)
- Button: "Xóa" (nếu có quyền)

**Nghiệp vụ chi tiết:**
1. User click vào thuốc từ màn hình Home
2. Gửi GET request đến `/api/medicines/{id}`
3. Backend lấy thông tin thuốc từ database
4. Trả về đầy đủ thông tin
5. Hiển thị trên UI

**Các action:**
- **Sửa**: Chuyển sang màn hình Edit Medicine
- **Xóa**: Hiển thị dialog xác nhận, nếu đồng ý → gọi DELETE API

---

#### **MÀN HÌNH 5: ADD MEDICINE (Thêm Thuốc Mới)**

**Chức năng:**
- UC7: Thêm thuốc mới

**Các thành phần UI:**
- Form gồm các TextField:
  - Tên thuốc* (bắt buộc)
  - Tên generic
  - Mã thuốc* (bắt buộc, unique)
  - Nhà sản xuất* (bắt buộc)
  - Mô tả
  - Đơn vị tính (viên, hộp, chai,...)
  - Giá* (bắt buộc, > 0)
  - Số lượng tồn kho* (bắt buộc, >= 0)
  - Số lượng tối thiểu
  - Số lô
  - Ngày hết hạn (DatePicker)
  - Danh mục (Dropdown)
  - Điều kiện bảo quản
  - Checkbox: Cần đơn thuốc
  - Button: Chọn hình ảnh (Image Picker)
- Button: "Lưu"
- Button: "Hủy"

**Nghiệp vụ chi tiết:**
1. User nhấn nút "+" từ màn hình Home
2. Hiển thị form thêm thuốc
3. User điền đầy đủ thông tin
4. Nhấn "Lưu"
5. Frontend validate:
   - Các trường bắt buộc không để trống
   - Giá > 0
   - Số lượng >= 0
6. Gửi POST request đến `/api/medicines` với JSON body
7. Backend validate:
   - Mã thuốc chưa tồn tại (unique constraint)
   - Các trường bắt buộc có giá trị
8. Backend lưu thuốc mới vào database
9. Trả về thông tin thuốc vừa tạo
10. Frontend hiển thị toast "Thêm thuốc thành công"
11. Quay về màn hình Home và refresh danh sách

**Validation:**
- Tên thuốc: bắt buộc
- Mã thuốc: bắt buộc, unique, format: MED001, MED002,...
- Nhà sản xuất: bắt buộc
- Giá: bắt buộc, number, > 0
- Số lượng: bắt buộc, integer, >= 0

---

#### **MÀN HÌNH 6: EDIT MEDICINE (Sửa Thuốc)**

**Chức năng:**
- UC8: Cập nhật thông tin thuốc

**Các thành phần UI:**
- Giống form Add Medicine nhưng đã điền sẵn dữ liệu hiện tại
- Button: "Cập nhật"
- Button: "Hủy"

**Nghiệp vụ chi tiết:**
1. User nhấn "Sửa" từ màn hình Chi tiết thuốc
2. Load dữ liệu hiện tại vào form
3. User thay đổi thông tin cần sửa
4. Nhấn "Cập nhật"
5. Frontend validate dữ liệu
6. Gửi PUT request đến `/api/medicines/{id}` với dữ liệu mới
7. Backend kiểm tra:
   - Thuốc có tồn tại không
   - Nếu đổi mã thuốc: mã mới chưa tồn tại
   - Các constraint khác
8. Backend cập nhật thông tin trong database
9. Trả về thông tin thuốc đã cập nhật
10. Hiển thị toast "Cập nhật thành công"
11. Quay về màn hình Chi tiết với dữ liệu mới

**Validation:**
- Giống Add Medicine
- Nếu đổi mã thuốc: phải unique

---

#### **MÀN HÌNH 7: PROFILE (Thông Tin Cá Nhân)**

**Chức năng:**
- Xem thông tin user
- Chuyển sang màn hình Change Password

**Các thành phần UI:**
- Avatar/Icon user
- Text: Username
- Text: Email
- Text: Full Name
- Text: Phone Number
- ListTile: "Đổi mật khẩu" → Chuyển màn hình
- Button: "Đăng xuất"

**Nghiệp vụ chi tiết:**
1. Load thông tin user từ token hoặc từ API
2. Hiển thị thông tin
3. User có thể:
   - Click "Đổi mật khẩu" → UC3
   - Click "Đăng xuất" → UC4

---

#### **MÀN HÌNH 8: CHANGE PASSWORD (Đổi Mật Khẩu)**

**Chức năng:**
- UC3: Đổi mật khẩu

**Các thành phần UI:**
- TextField: Current Password (mật khẩu hiện tại)
- TextField: New Password (mật khẩu mới)
- TextField: Confirm New Password (xác nhận mật khẩu mới)
- Button: "Đổi mật khẩu"
- Button: "Hủy"

**Nghiệp vụ chi tiết:**
1. User nhập 3 trường
2. Nhấn "Đổi mật khẩu"
3. Frontend validate:
   - Các trường không để trống
   - New Password != Current Password
   - New Password == Confirm New Password
   - New Password >= 6 ký tự
4. Gửi POST request đến `/api/auth/change-password`
5. Backend kiểm tra:
   - Current Password đúng với password trong database
   - New Password khác Current Password
6. Backend mã hóa New Password bằng BCrypt
7. Cập nhật password trong database
8. Xóa tất cả refresh token của user (force logout)
9. Frontend xóa token local
10. Chuyển về màn hình Login
11. User phải đăng nhập lại với password mới

**Validation:**
- Current Password: bắt buộc
- New Password: bắt buộc, >= 6 ký tự, khác Current Password
- Confirm New Password: phải khớp với New Password

---

### 2.3. Tóm Tắt Chức Năng

| # | Chức Năng | Màn Hình | Actor | Mô Tả Ngắn |
|---|-----------|----------|-------|------------|
| UC1 | Đăng ký | Register | Guest | Tạo tài khoản mới |
| UC2 | Đăng nhập | Login | Guest | Xác thực và lấy token |
| UC3 | Đổi mật khẩu | Change Password | User | Cập nhật mật khẩu |
| UC4 | Đăng xuất | Profile | User | Xóa token, quay về Login |
| UC5 | Xem DS thuốc | Home | User | Hiển thị danh sách thuốc |
| UC6 | Xem CT thuốc | Medicine Detail | User | Hiển thị thông tin đầy đủ |
| UC7 | Thêm thuốc | Add Medicine | User | Thêm thuốc mới vào hệ thống |
| UC8 | Sửa thuốc | Edit Medicine | User | Cập nhật thông tin thuốc |
| UC9 | Xóa thuốc | Medicine Detail | User | Xóa thuốc (soft delete) |

---

## 🗄️ PHẦN 3: DATABASE

### 3.1. Database Sử Dụng

**Hệ quản trị CSDL:** PostgreSQL 15.x  
*(Có thể thay thế bằng MySQL 8.x)*

**Lý do chọn PostgreSQL:**
- Mã nguồn mở, miễn phí
- Hiệu năng cao
- Hỗ trợ tốt các kiểu dữ liệu phức tạp
- ACID compliance (đảm bảo tính toàn vẹn dữ liệu)

### 3.2. Schema Database Chi Tiết

#### **TABLE 1: users**

```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,  -- BCrypt hashed
    full_name VARCHAR(100),
    phone_number VARCHAR(20),
    role VARCHAR(20) DEFAULT 'USER',  -- USER, ADMIN, MANAGER
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index để tăng tốc truy vấn
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
```

**Mô tả các trường:**
- `id`: Khóa chính, tự động tăng
- `username`: Tên đăng nhập, unique, dùng để login
- `email`: Email, unique, dùng để liên hệ
- `password`: Mật khẩu đã mã hóa BCrypt (60 ký tự)
- `full_name`: Họ tên đầy đủ
- `phone_number`: Số điện thoại
- `role`: Phân quyền (USER, ADMIN, MANAGER)
- `is_active`: Trạng thái tài khoản (true/false)
- `created_at`: Thời gian tạo
- `updated_at`: Thời gian cập nhật cuối

**Dữ liệu mẫu:**
```sql
INSERT INTO users (username, email, password, full_name, phone_number, role) 
VALUES 
('admin', 'admin@pharmacy.com', '$2a$10$...', 'Quản Trị Viên', '0901234567', 'ADMIN'),
('staff01', 'staff01@pharmacy.com', '$2a$10$...', 'Nhân Viên 1', '0907654321', 'USER');
```

---

#### **TABLE 2: medicines**

```sql
CREATE TABLE medicines (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    generic_name VARCHAR(255),
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    manufacturer VARCHAR(255) NOT NULL,
    unit_of_measure VARCHAR(50),  -- viên, hộp, chai, lọ
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    quantity_in_stock INTEGER NOT NULL DEFAULT 0 CHECK (quantity_in_stock >= 0),
    minimum_stock INTEGER DEFAULT 10,
    batch_number VARCHAR(100),
    expiry_date DATE,
    category VARCHAR(100),  -- Kháng sinh, Giảm đau, Vitamin, ...
    storage_condition VARCHAR(255),  -- Bảo quản nơi khô ráo, tránh ánh sáng
    prescription_required BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT REFERENCES users(id),
    updated_by BIGINT REFERENCES users(id)
);

-- Index để tăng tốc truy vấn
CREATE INDEX idx_medicines_code ON medicines(code);
CREATE INDEX idx_medicines_name ON medicines(name);
CREATE INDEX idx_medicines_category ON medicines(category);
CREATE INDEX idx_medicines_expiry_date ON medicines(expiry_date);
```

**Mô tả các trường:**
- `id`: Khóa chính
- `name`: Tên thuốc thương mại (VD: Paracetamol 500mg)
- `generic_name`: Tên hoạt chất (VD: Paracetamol)
- `code`: Mã thuốc, unique (VD: MED001)
- `description`: Mô tả chi tiết, công dụng
- `manufacturer`: Nhà sản xuất
- `unit_of_measure`: Đơn vị tính (viên, hộp, chai, lọ)
- `price`: Giá bán (VNĐ)
- `quantity_in_stock`: Số lượng tồn kho
- `minimum_stock`: Số lượng tồn tối thiểu để cảnh báo
- `batch_number`: Số lô sản xuất
- `expiry_date`: Ngày hết hạn
- `category`: Danh mục thuốc
- `storage_condition`: Điều kiện bảo quản
- `prescription_required`: Có cần đơn thuốc không
- `is_active`: Trạng thái (true: đang kinh doanh, false: ngừng kinh doanh)
- `image_url`: URL hình ảnh thuốc
- `created_at`: Thời gian tạo
- `updated_at`: Thời gian cập nhật
- `created_by`: User tạo (foreign key)
- `updated_by`: User cập nhật cuối (foreign key)

**Dữ liệu mẫu:**
```sql
INSERT INTO medicines (name, code, manufacturer, price, quantity_in_stock, category, created_by) 
VALUES 
('Paracetamol 500mg', 'MED001', 'DHG Pharma', 50000, 100, 'Giảm đau - Hạ sốt', 1),
('Amoxicillin 500mg', 'MED002', 'Traphaco', 80000, 50, 'Kháng sinh', 1),
('Vitamin C 500mg', 'MED003', 'Imexpharm', 120000, 200, 'Vitamin', 1);
```

---

#### **TABLE 3: refresh_tokens**

```sql
CREATE TABLE refresh_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    expiry_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);
```

**Mô tả:**
- Lưu trữ refresh token để làm mới access token
- Mỗi user có thể có nhiều refresh token (đăng nhập nhiều thiết bị)
- Khi đổi password, xóa tất cả refresh token của user đó

---

### 3.3. Quan Hệ Giữa Các Bảng

```
users (1) ---< (N) medicines (created_by)
users (1) ---< (N) medicines (updated_by)
users (1) ---< (N) refresh_tokens
```

**Giải thích:**
- 1 user có thể tạo nhiều thuốc (medicines.created_by)
- 1 user có thể cập nhật nhiều thuốc (medicines.updated_by)
- 1 user có thể có nhiều refresh token (đăng nhập nhiều thiết bị)

---

### 3.4. Các Query Thường Dùng

#### **1. Lấy tất cả thuốc đang hoạt động**
```sql
SELECT id, name, code, price, quantity_in_stock
FROM medicines
WHERE is_active = TRUE
ORDER BY created_at DESC;
```

#### **2. Tìm kiếm thuốc theo tên hoặc mã**
```sql
SELECT *
FROM medicines
WHERE is_active = TRUE
  AND (name ILIKE '%keyword%' OR code ILIKE '%keyword%')
ORDER BY name;
```

#### **3. Lấy danh sách thuốc sắp hết hạn (trong vòng 30 ngày)**
```sql
SELECT name, code, expiry_date, DATEDIFF(expiry_date, CURRENT_DATE) AS days_left
FROM medicines
WHERE is_active = TRUE
  AND expiry_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
ORDER BY expiry_date ASC;
```

#### **4. Lấy danh sách thuốc sắp hết hàng (số lượng <= minimum_stock)**
```sql
SELECT name, code, quantity_in_stock, minimum_stock
FROM medicines
WHERE is_active = TRUE
  AND quantity_in_stock <= minimum_stock
ORDER BY quantity_in_stock ASC;
```

#### **5. Kiểm tra mã thuốc đã tồn tại chưa**
```sql
SELECT COUNT(*) 
FROM medicines 
WHERE code = 'MED001';
-- Nếu kết quả > 0 thì đã tồn tại
```

#### **6. Thống kê số lượng thuốc theo danh mục**
```sql
SELECT category, COUNT(*) AS total, SUM(quantity_in_stock) AS total_stock
FROM medicines
WHERE is_active = TRUE
GROUP BY category
ORDER BY total DESC;
```

#### **7. Lấy thông tin user đã tạo thuốc**
```sql
SELECT m.name, m.code, u.username, u.full_name, m.created_at
FROM medicines m
INNER JOIN users u ON m.created_by = u.id
ORDER BY m.created_at DESC;
```

---

## 🎬 PHẦN 4: KỊCH BẢN DEMO

### 4.1. Demo Scenario 1: Đăng Ký và Đăng Nhập

**Các bước demo:**

1. **Mở ứng dụng**
   - Màn hình Login xuất hiện

2. **Nhấn "Đăng ký ngay"**
   - Chuyển sang màn hình Register

3. **Điền form đăng ký:**
   ```
   Username: testuser
   Email: testuser@example.com
   Full Name: Nguyễn Văn Test
   Phone: 0912345678
   Password: 123456
   Confirm Password: 123456
   ```

4. **Nhấn "Đăng ký"**
   - Hiển thị toast "Đăng ký thành công!"
   - Chuyển về màn hình Login

5. **Nhập thông tin đăng nhập:**
   ```
   Username: testuser
   Password: 123456
   ```

6. **Nhấn "Đăng nhập"**
   - Hiển thị loading
   - Chuyển sang màn hình Home
   - Hiển thị danh sách thuốc

**Giải thích cho giảng viên:**
- Backend sẽ mã hóa password bằng BCrypt trước khi lưu vào database
- Khi đăng nhập thành công, server tạo JWT token
- Token được lưu trong SharedPreferences
- Mọi request sau này sẽ gửi kèm token trong header

---

### 4.2. Demo Scenario 2: Quản Lý Thuốc

**DEMO A: Thêm Thuốc Mới**

1. **Ở màn hình Home, nhấn nút "+"**
   - Chuyển sang màn hình Add Medicine

2. **Điền form thêm thuốc:**
   ```
   Tên thuốc: Paracetamol 500mg
   Tên generic: Paracetamol
   Mã thuốc: MED001
   Nhà sản xuất: DHG Pharma
   Mô tả: Thuốc giảm đau, hạ sốt
   Đơn vị tính: Hộp
   Giá: 50000
   Số lượng: 100
   Số lượng tối thiểu: 10
   Ngày hết hạn: 2025-12-31
   Danh mục: Giảm đau - Hạ sốt
   ```

3. **Nhấn "Lưu"**
   - Hiển thị toast "Thêm thuốc thành công!"
   - Quay về Home
   - Thuốc mới xuất hiện ở đầu danh sách

**Giải thích:**
- Backend kiểm tra mã thuốc MED001 chưa tồn tại
- Nếu đã tồn tại → trả về lỗi 409 Conflict
- Sau khi lưu thành công, tự động thêm created_by = user hiện tại

---

**DEMO B: Xem Chi Tiết Thuốc**

1. **Click vào thuốc "Paracetamol 500mg"**
   - Chuyển sang màn hình Medicine Detail

2. **Hiển thị đầy đủ thông tin:**
   - Hình ảnh thuốc (nếu có)
   - Tất cả các trường đã nhập
   - Thời gian tạo, người tạo

---

**DEMO C: Sửa Thuốc**

1. **Ở màn hình Chi tiết, nhấn "Sửa"**
   - Chuyển sang màn hình Edit Medicine
   - Dữ liệu hiện tại đã được điền sẵn

2. **Thay đổi giá:**
   ```
   Giá: 50000 → 55000
   Số lượng: 100 → 95
   ```

3. **Nhấn "Cập nhật"**
   - Hiển thị toast "Cập nhật thành công!"
   - Quay về Chi tiết với dữ liệu mới

**Giải thích:**
- Backend ghi lại thời gian updated_at
- Backend lưu user hiện tại vào updated_by

---

**DEMO D: Xóa Thuốc**

1. **Ở màn hình Chi tiết, nhấn "Xóa"**
   - Hiển thị dialog xác nhận:
     > "Bạn có chắc muốn xóa thuốc Paracetamol 500mg?  
     > Hành động này không thể hoàn tác!"

2. **Nhấn "Xác nhận"**
   - Gửi DELETE request
   - Hiển thị toast "Xóa thuốc thành công!"
   - Quay về Home
   - Thuốc không còn trong danh sách

**Giải thích:**
- Hệ thống sử dụng **soft delete** (không xóa hẳn)
- Backend chỉ set `is_active = FALSE`
- Dữ liệu vẫn còn trong database (có thể khôi phục)

---

### 4.3. Demo Scenario 3: Đổi Mật Khẩu

1. **Ở màn hình Home, nhấn icon Profile**
   - Chuyển sang màn hình Profile

2. **Nhấn "Đổi mật khẩu"**
   - Chuyển sang màn hình Change Password

3. **Điền thông tin:**
   ```
   Current Password: 123456
   New Password: 654321
   Confirm New Password: 654321
   ```

4. **Nhấn "Đổi mật khẩu"**
   - Hiển thị toast "Đổi mật khẩu thành công!"
   - Tự động đăng xuất
   - Quay về màn hình Login

5. **Đăng nhập lại với password mới:**
   ```
   Username: testuser
   Password: 654321
   ```

6. **Đăng nhập thành công**

**Giải thích:**
- Backend kiểm tra Current Password có đúng không
- Mã hóa New Password bằng BCrypt
- Cập nhật password trong database
- Xóa tất cả refresh token → Force logout tất cả thiết bị
- User phải đăng nhập lại

---

## 💻 PHẦN 5: CÂU HỎI VỀ CODE VÀ GIẢI THÍCH NGHIỆP VỤ

### 5.1. Câu Hỏi: "Giờ lấy ra danh sách thuốc có giá từ 50,000 đến 100,000, sắp xếp theo giá tăng dần"

**Query SQL:**
```sql
SELECT id, name, code, manufacturer, price, quantity_in_stock
FROM medicines
WHERE is_active = TRUE
  AND price BETWEEN 50000 AND 100000
ORDER BY price ASC;
```

**Code trong MedicineRepository (Java):**
```java
public interface MedicineRepository extends JpaRepository<Medicine, Long> {
    
    @Query("SELECT m FROM Medicine m WHERE m.isActive = true AND m.price BETWEEN :minPrice AND :maxPrice ORDER BY m.price ASC")
    List<Medicine> findMedicinesByPriceRange(
        @Param("minPrice") BigDecimal minPrice, 
        @Param("maxPrice") BigDecimal maxPrice
    );
}
```

**Code trong MedicineService:**
```java
public List<MedicineDTO> getMedicinesByPriceRange(BigDecimal minPrice, BigDecimal maxPrice) {
    List<Medicine> medicines = medicineRepository.findMedicinesByPriceRange(minPrice, maxPrice);
    return medicines.stream()
                   .map(this::convertToDTO)
                   .collect(Collectors.toList());
}
```

**Code trong Controller:**
```java
@GetMapping("/price-range")
public ResponseEntity<List<MedicineDTO>> getMedicinesByPriceRange(
        @RequestParam BigDecimal minPrice,
        @RequestParam BigDecimal maxPrice) {
    List<MedicineDTO> medicines = medicineService.getMedicinesByPriceRange(minPrice, maxPrice);
    return ResponseEntity.ok(medicines);
}
```

**Call API:**
```
GET /api/medicines/price-range?minPrice=50000&maxPrice=100000
```

---

### 5.2. Câu Hỏi: "Lấy ra thuốc của danh mục 'Kháng sinh' và số lượng tồn <= 20"

**Query SQL:**
```sql
SELECT *
FROM medicines
WHERE is_active = TRUE
  AND category = 'Kháng sinh'
  AND quantity_in_stock <= 20
ORDER BY quantity_in_stock ASC;
```

**Code Repository:**
```java
List<Medicine> findByIsActiveTrueAndCategoryAndQuantityInStockLessThanEqual(
    String category, 
    Integer maxQuantity
);
```

**Code Service:**
```java
public List<MedicineDTO> getMedicinesByCategoryAndLowStock(String category, Integer maxQuantity) {
    List<Medicine> medicines = medicineRepository
        .findByIsActiveTrueAndCategoryAndQuantityInStockLessThanEqual(category, maxQuantity);
    return medicines.stream()
                   .map(this::convertToDTO)
                   .collect(Collectors.toList());
}
```

---

### 5.3. Câu Hỏi: "Xóa hàm deleteMedicine và code lại"

**Hàm cũ (Soft Delete):**
```java
@Transactional
public void deleteMedicine(Long id) {
    Medicine medicine = medicineRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy thuốc với ID: " + id));
    
    medicine.setActive(false);  // Soft delete
    medicineRepository.save(medicine);
}
```

**Giảng viên yêu cầu: Hard Delete (Xóa hẳn)**

**Code lại:**
```java
@Transactional
public void deleteMedicine(Long id) {
    // Kiểm tra thuốc có tồn tại không
    if (!medicineRepository.existsById(id)) {
        throw new ResourceNotFoundException("Không tìm thấy thuốc với ID: " + id);
    }
    
    // Xóa vĩnh viễn khỏi database
    medicineRepository.deleteById(id);
}
```

**Giải thích sự khác biệt:**
- **Soft Delete**: Chỉ set `is_active = FALSE`, dữ liệu vẫn còn trong DB
  - Ưu điểm: Có thể khôi phục, audit trail
  - Nhược điểm: Database ngày càng lớn
- **Hard Delete**: Xóa hẳn record khỏi database
  - Ưu điểm: Tiết kiệm dung lượng
  - Nhược điểm: Mất dữ liệu vĩnh viễn

---

### 5.4. Câu Hỏi: "Giải thích flow của hàm createMedicine"

**Code:**
```java
@Transactional
public MedicineDTO createMedicine(MedicineDTO medicineDTO) {
    // Bước 1: Kiểm tra mã thuốc đã tồn tại chưa
    if (medicineRepository.existsByCode(medicineDTO.getCode())) {
        throw new ResourceAlreadyExistsException("Mã thuốc đã tồn tại: " + medicineDTO.getCode());
    }
    
    // Bước 2: Tạo entity Medicine từ DTO
    Medicine medicine = new Medicine();
    BeanUtils.copyProperties(medicineDTO, medicine, "id", "createdAt", "updatedAt");
    
    // Bước 3: Lấy thông tin user đang đăng nhập
    User currentUser = getCurrentUser();
    medicine.setCreatedBy(currentUser);
    
    // Bước 4: Lưu vào database
    Medicine savedMedicine = medicineRepository.save(medicine);
    
    // Bước 5: Convert sang DTO và return
    return convertToDTO(savedMedicine);
}
```

**Flow chi tiết:**

1. **Validation**: Kiểm tra mã thuốc (code) chưa tồn tại
   - Query: `SELECT COUNT(*) FROM medicines WHERE code = ?`
   - Nếu tồn tại → throw exception → trả về lỗi 409 Conflict
   
2. **Mapping**: Convert DTO → Entity
   - Copy các field từ MedicineDTO sang Medicine
   - Bỏ qua các field: id, createdAt, updatedAt (tự động generate)

3. **Authentication**: Lấy user hiện tại từ SecurityContext
   - Lấy username từ JWT token
   - Query user từ database
   - Set vào field `createdBy`

4. **Persist**: Lưu entity vào database
   - Hibernate tự động generate id
   - Trigger `@CreationTimestamp` → set createdAt
   - INSERT INTO medicines VALUES (...)

5. **Response**: Convert Entity → DTO
   - Tạo MedicineDTO mới
   - Copy các field từ Medicine entity
   - Return về Controller
   - Controller wrap trong ResponseEntity
   - Trả về client dưới dạng JSON

**Transaction:**
- Annotation `@Transactional` đảm bảo toàn bộ quá trình thành công hoặc rollback
- Nếu có lỗi ở bất kỳ bước nào → rollback, không lưu vào DB

---

### 5.5. Câu Hỏi: "Code như vậy có đúng nghiệp vụ chưa? Nói lại nghiệp vụ"

**Đánh giá code:**

✅ **Những gì đã đúng:**
1. Validation mã thuốc unique
2. Kiểm tra thuốc tồn tại trước khi update/delete
3. Soft delete để giữ lại dữ liệu
4. Lưu thông tin user tạo/sửa (audit trail)
5. Phân trang khi lấy danh sách
6. Authentication và Authorization với JWT
7. Validation các trường bắt buộc
8. Handle exception đúng cách

⚠️ **Những gì có thể cải thiện:**
1. **Kiểm tra số lượng âm**: Cần validate `quantityInStock >= 0`
2. **Kiểm tra ngày hết hạn**: Cần cảnh báo nếu thêm thuốc đã hết hạn
3. **Log**: Nên thêm logging để trace
4. **Cache**: Có thể cache danh sách thuốc để giảm query
5. **Tìm kiếm**: Nên hỗ trợ full-text search
6. **Phân quyền**: Cần phân quyền rõ ràng hơn (ADMIN, MANAGER, STAFF)

**Nghiệp vụ quản lý thuốc chuẩn:**

1. **Khi thêm thuốc mới:**
   - Kiểm tra mã thuốc unique
   - Kiểm tra giá > 0
   - Kiểm tra số lượng >= 0
   - Kiểm tra ngày hết hạn > ngày hiện tại
   - Lưu thông tin người tạo
   - Ghi log

2. **Khi cập nhật thuốc:**
   - Kiểm tra thuốc có tồn tại
   - Nếu đổi mã: kiểm tra mã mới chưa tồn tại
   - Validate các constraint
   - Lưu thông tin người sửa
   - Ghi log thay đổi

3. **Khi xóa thuốc:**
   - Kiểm tra thuốc có tồn tại
   - Kiểm tra thuốc có đang trong đơn hàng nào không (nếu có module Order)
   - Nếu đang có đơn → không cho xóa, chỉ cho inactive
   - Nếu không có → cho phép xóa
   - Ghi log

4. **Cảnh báo:**
   - Cảnh báo thuốc sắp hết hạn (30 ngày)
   - Cảnh báo thuốc sắp hết hàng (quantity <= minimumStock)
   - Gửi notification cho admin

5. **Báo cáo:**
   - Thống kê thuốc theo danh mục
   - Thống kê giá trị tồn kho
   - Báo cáo thuốc bán chạy (nếu có module Order)

---

## 🔄 PHẦN 6: QUY TRÌNH ỨNG DỤNG

### 6.1. Quy Trình Đăng Ký và Đăng Nhập

```
[User] → Nhập thông tin đăng ký
   ↓
[Flutter App] → Validate dữ liệu (client-side)
   ↓
[POST /api/auth/register] → Gửi request
   ↓
[AuthController] → Nhận request
   ↓
[AuthService] → Xử lý logic
   ↓
[Validate] → Kiểm tra username/email chưa tồn tại
   ↓
[BCrypt] → Mã hóa password
   ↓
[UserRepository] → Lưu user vào database
   ↓
[Response] → Trả về success
   ↓
[Flutter App] → Hiển thị "Đăng ký thành công"
   ↓
[Navigate] → Chuyển về Login Screen

---

[User] → Nhập username + password
   ↓
[POST /api/auth/login] → Gửi request
   ↓
[AuthController] → Nhận request
   ↓
[AuthService] → Xử lý login
   ↓
[UserDetailsService] → Load user từ DB
   ↓
[PasswordEncoder] → So sánh password
   ↓
[JwtUtils] → Tạo Access Token (15 phút)
   ↓
[JwtUtils] → Tạo Refresh Token (7 ngày)
   ↓
[Response] → Trả về {user, accessToken, refreshToken}
   ↓
[Flutter App] → Lưu token vào SharedPreferences
   ↓
[Navigate] → Chuyển sang Home Screen
```

---

### 6.2. Quy Trình Quản Lý Thuốc

```
[User] → Xem danh sách thuốc
   ↓
[GET /api/medicines] + Header: Authorization: Bearer {token}
   ↓
[AuthTokenFilter] → Kiểm tra token hợp lệ
   ↓
[MedicineController] → Nhận request
   ↓
[MedicineService] → Xử lý logic
   ↓
[MedicineRepository] → Query DB: SELECT * FROM medicines WHERE is_active = TRUE
   ↓
[Response] → Trả về List<MedicineDTO>
   ↓
[Flutter App] → Parse JSON → Hiển thị GridView

---

[User] → Nhấn "Thêm thuốc"
   ↓
[Flutter App] → Hiển thị Form
   ↓
[User] → Điền thông tin → Nhấn "Lưu"
   ↓
[Validate] → Kiểm tra dữ liệu
   ↓
[POST /api/medicines] + Body: MedicineDTO + Token
   ↓
[AuthTokenFilter] → Verify token
   ↓
[PreAuthorize] → Kiểm tra quyền ADMIN/MANAGER
   ↓
[MedicineController.createMedicine()] → Nhận request
   ↓
[MedicineService.createMedicine()] → Xử lý
   ↓
[Check] → Mã thuốc chưa tồn tại
   ↓
[Mapping] → DTO → Entity
   ↓
[Set] → createdBy = currentUser
   ↓
[Save] → INSERT INTO medicines (...)
   ↓
[Response] → Trả về MedicineDTO
   ↓
[Flutter App] → Toast "Thành công" → Refresh danh sách
```

---

### 6.3. Luồng Xử Lý Exception

```
[Request] → Có lỗi xảy ra
   ↓
[Service Layer] → Throw Exception
   ↓
[GlobalExceptionHandler] → Bắt exception
   ↓
[Determine Type] → Xác định loại exception
   ├─ ResourceNotFoundException → 404 Not Found
   ├─ ResourceAlreadyExistsException → 409 Conflict
   ├─ BadRequestException → 400 Bad Request
   ├─ ValidationException → 400 Bad Request
   └─ Other → 500 Internal Server Error
   ↓
[Build Response] → {message, status, timestamp}
   ↓
[Return] → ResponseEntity
   ↓
[Flutter App] → Parse error → Hiển thị toast lỗi
```

---

## 🔐 PHẦN 7: BẢO MẬT

### 7.1. Authentication (Xác Thực)

**Cơ chế: JWT (JSON Web Token)**

**Flow đầy đủ:**

```
1. User đăng nhập
   ↓
2. Backend xác thực username + password
   ↓
3. Backend tạo 2 token:
   ┌─────────────────────────────────┐
   │ Access Token                    │
   │ - Chứa: userId, username, role  │
   │ - Thời hạn: 15 phút             │
   │ - Dùng để: Gọi API              │
   └─────────────────────────────────┘
   
   ┌─────────────────────────────────┐
   │ Refresh Token                   │
   │ - Chứa: random UUID             │
   │ - Thời hạn: 7 ngày              │
   │ - Dùng để: Làm mới Access Token │
   │ - Lưu trong DB (table refresh_tokens) │
   └─────────────────────────────────┘
   ↓
4. Frontend lưu 2 token vào SharedPreferences
   ↓
5. Mỗi API request gửi kèm: Authorization: Bearer {accessToken}
   ↓
6. Backend verify token:
   - Signature đúng không?
   - Hết hạn chưa?
   - User còn tồn tại không?
   ↓
7. Nếu Access Token hết hạn:
   → Gửi Refresh Token lên server
   → Server kiểm tra Refresh Token có trong DB không
   → Nếu hợp lệ: Tạo Access Token mới
   → Nếu không hợp lệ: Bắt đăng nhập lại
```

**Code JWT Token:**

```java
// Tạo Access Token
public String generateAccessToken(UserDetails userDetails) {
    return Jwts.builder()
            .setSubject(userDetails.getUsername())
            .claim("role", userDetails.getAuthorities())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + 900000)) // 15 phút
            .signWith(SignatureAlgorithm.HS512, jwtSecret)
            .compact();
}

// Verify Token
public boolean validateToken(String token) {
    try {
        Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token);
        return true;
    } catch (JwtException e) {
        return false;
    }
}

// Lấy username từ token
public String getUsernameFromToken(String token) {
    Claims claims = Jwts.parser()
            .setSigningKey(jwtSecret)
            .parseClaimsJws(token)
            .getBody();
    return claims.getSubject();
}
```

**AuthTokenFilter (Interceptor):**

```java
@Override
protected void doFilterInternal(HttpServletRequest request, 
                                HttpServletResponse response, 
                                FilterChain filterChain) {
    try {
        // 1. Lấy token từ header
        String jwt = parseJwt(request);
        
        // 2. Validate token
        if (jwt != null && jwtUtils.validateToken(jwt)) {
            // 3. Lấy username từ token
            String username = jwtUtils.getUsernameFromToken(jwt);
            
            // 4. Load user từ DB
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);
            
            // 5. Tạo Authentication object
            UsernamePasswordAuthenticationToken authentication = 
                new UsernamePasswordAuthenticationToken(
                    userDetails, null, userDetails.getAuthorities()
                );
            
            // 6. Set vào SecurityContext
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }
    } catch (Exception e) {
        logger.error("Cannot set user authentication: {}", e.getMessage());
    }
    
    filterChain.doFilter(request, response);
}
```

---

### 7.2. Authorization (Phân Quyền)

**Các Role:**
- `USER`: Người dùng thường, có thể xem thuốc
- `MANAGER`: Quản lý, có thể thêm/sửa thuốc
- `ADMIN`: Quản trị viên, có quyền xóa thuốc

**Code phân quyền:**

```java
// Chỉ ADMIN và MANAGER mới được thêm thuốc
@PostMapping
@PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
public ResponseEntity<MedicineDTO> createMedicine(@RequestBody MedicineDTO medicineDTO) {
    // ...
}

// Chỉ ADMIN mới được xóa thuốc
@DeleteMapping("/{id}")
@PreAuthorize("hasRole('ADMIN')")
public ResponseEntity<Map<String, String>> deleteMedicine(@PathVariable Long id) {
    // ...
}
```

---

### 7.3. Password Security (Bảo Mật Mật Khẩu)

**Mã hóa: BCrypt**

**Đặc điểm:**
- One-way hash (không thể decode)
- Tự động thêm salt (ngẫu nhiên)
- Mỗi lần hash cùng 1 password → kết quả khác nhau
- Kiểm tra password bằng hàm `matches()`

**Code:**

```java
// Mã hóa password khi đăng ký
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}

// Đăng ký
public void register(RegisterDTO dto) {
    User user = new User();
    user.setUsername(dto.getUsername());
    
    // Mã hóa password
    String encodedPassword = passwordEncoder.encode(dto.getPassword());
    user.setPassword(encodedPassword);
    
    userRepository.save(user);
}

// Đăng nhập - So sánh password
public boolean authenticate(String username, String rawPassword) {
    User user = userRepository.findByUsername(username);
    if (user == null) return false;
    
    // So sánh password nhập vào với hash trong DB
    return passwordEncoder.matches(rawPassword, user.getPassword());
}
```

**Ví dụ:**
```
Input: 123456
BCrypt Hash: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy

Input: 123456 (lần 2)
BCrypt Hash: $2a$10$X9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWz
→ Khác nhau!
```

---

### 7.4. Input Validation (Kiểm Tra Dữ Liệu Đầu Vào)

**1. Frontend Validation (Flutter):**
```dart
String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username không được để trống';
  }
  if (value.length < 3 || value.length > 50) {
    return 'Username phải từ 3-50 ký tự';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email không được để trống';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Email không hợp lệ';
  }
  return null;
}

String? validatePrice(String? value) {
  if (value == null || value.isEmpty) {
    return 'Giá không được để trống';
  }
  final price = double.tryParse(value);
  if (price == null || price <= 0) {
    return 'Giá phải lớn hơn 0';
  }
  return null;
}
```

**2. Backend Validation (Java):**
```java
@Data
public class MedicineDTO {
    
    @NotBlank(message = "Tên thuốc không được để trống")
    @Size(min = 1, max = 255, message = "Tên thuốc từ 1-255 ký tự")
    private String name;
    
    @NotBlank(message = "Mã thuốc không được để trống")
    @Pattern(regexp = "^MED\\d{3,}$", message = "Mã thuốc phải có định dạng MED001")
    private String code;
    
    @NotNull(message = "Giá không được để trống")
    @DecimalMin(value = "0.01", message = "Giá phải lớn hơn 0")
    private BigDecimal price;
    
    @NotNull(message = "Số lượng không được để trống")
    @Min(value = 0, message = "Số lượng không được âm")
    private Integer quantityInStock;
    
    @Email(message = "Email không hợp lệ")
    private String email;
}
```

**Controller sử dụng `@Valid`:**
```java
@PostMapping
public ResponseEntity<MedicineDTO> createMedicine(@Valid @RequestBody MedicineDTO medicineDTO) {
    // Nếu validation fail → tự động throw MethodArgumentNotValidException
    // GlobalExceptionHandler bắt và trả về 400 Bad Request
    return ResponseEntity.ok(medicineService.createMedicine(medicineDTO));
}
```

---

### 7.5. SQL Injection Prevention

**Nguy hiểm:**
```sql
-- User nhập: ' OR '1'='1
SELECT * FROM users WHERE username = '' OR '1'='1' AND password = ''
→ Luôn trả về TRUE → Bypass login!
```

**Cách phòng chống:**

✅ **Sử dụng Prepared Statement / JPA Query:**
```java
// KHÔNG BAO GIỜ làm như này:
String query = "SELECT * FROM users WHERE username = '" + username + "'";

// Đúng cách:
@Query("SELECT u FROM User u WHERE u.username = :username")
User findByUsername(@Param("username") String username);
```

JPA tự động escape các ký tự đặc biệt.

---

### 7.6. XSS Prevention (Cross-Site Scripting)

**Nguy hiểm:**
```
User nhập tên thuốc: <script>alert('Hacked!')</script>
→ Khi hiển thị → Script được thực thi!
```

**Cách phòng chống:**
- Frontend: Sử dụng Text widget (Flutter tự động escape)
- Backend: Validate không cho nhập HTML tags
- Database: Lưu raw text, không parse HTML

```java
@NotBlank
@Pattern(regexp = "^[^<>]*$", message = "Không được chứa ký tự < hoặc >")
private String name;
```

---

### 7.7. CORS (Cross-Origin Resource Sharing)

**Config:**
```java
@Configuration
public class SecurityConfig {
    
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("http://localhost:3000", "https://pharmacy.com"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
```

---

## ✅ PHẦN 8: QUY TẮC THIẾT KẾ

### 8.1. Quy Tắc Nhập/Sửa Dữ Liệu

**1. Validation phải đảm bảo:**
- ✅ Các trường bắt buộc không để trống
- ✅ Kiểu dữ liệu đúng (string, number, date)
- ✅ Range hợp lệ (giá > 0, số lượng >= 0)
- ✅ Format đúng (email, phone, date)
- ✅ Unique constraint (username, email, mã thuốc)
- ✅ Foreign key tồn tại (nếu có)

**2. Error Handling:**
- ✅ Hiển thị lỗi rõ ràng, dễ hiểu
- ✅ Lỗi phải ở ngôn ngữ người dùng (Tiếng Việt)
- ✅ Lỗi phải chỉ ra trường nào bị sai
- ✅ Không để lộ thông tin hệ thống

**3. User Experience:**
- ✅ Hiển thị loading khi xử lý
- ✅ Disable button sau khi submit (tránh double-click)
- ✅ Confirm trước khi xóa
- ✅ Toast/Snackbar thông báo thành công

---

### 8.2. Quy Tắc Xác Thực (Authentication)

**1. Đăng ký:**
- ✅ Username: 3-50 ký tự, chỉ chứa chữ, số, dấu gạch dưới
- ✅ Email: Format đúng, unique
- ✅ Password: Tối thiểu 6 ký tự
- ✅ Confirm Password phải khớp
- ✅ Mã hóa password trước khi lưu

**2. Đăng nhập:**
- ✅ Kiểm tra username tồn tại
- ✅ So sánh password hash
- ✅ Tạo JWT token nếu đúng
- ✅ Lưu token an toàn (SharedPreferences/Keychain)
- ✅ Giới hạn số lần đăng nhập sai (rate limiting)

**3. Token Management:**
- ✅ Access Token: Thời hạn ngắn (15 phút)
- ✅ Refresh Token: Thời hạn dài (7 ngày)
- ✅ Refresh Token lưu trong database
- ✅ Xóa token khi đăng xuất
- ✅ Xóa tất cả token khi đổi password

**4. Session Management:**
- ✅ Tự động đăng xuất khi token hết hạn
- ✅ Tự động làm mới token nếu có refresh token
- ✅ Kiểm tra token mỗi khi gọi API
- ✅ Chuyển về Login nếu unauthorized

---

### 8.3. Quy Tắc REST API

**1. HTTP Methods:**
- `GET`: Lấy dữ liệu (không thay đổi)
- `POST`: Tạo mới
- `PUT`: Cập nhật toàn bộ
- `PATCH`: Cập nhật một phần
- `DELETE`: Xóa

**2. Status Codes:**
- `200 OK`: Thành công
- `201 Created`: Tạo mới thành công
- `400 Bad Request`: Dữ liệu không hợp lệ
- `401 Unauthorized`: Chưa đăng nhập
- `403 Forbidden`: Không có quyền
- `404 Not Found`: Không tìm thấy
- `409 Conflict`: Dữ liệu trùng lặp
- `500 Internal Server Error`: Lỗi server

**3. Response Format:**
```json
// Success
{
  "data": {...},
  "message": "Thành công",
  "timestamp": "2025-01-01T10:00:00"
}

// Error
{
  "error": "Mã thuốc đã tồn tại",
  "status": 409,
  "timestamp": "2025-01-01T10:00:00",
  "path": "/api/medicines"
}
```

---

### 8.4. Quy Tắc Clean Code

**1. Naming:**
- Class: PascalCase (MedicineService)
- Method: camelCase (getMedicineById)
- Variable: camelCase (medicineDTO)
- Constant: UPPER_SNAKE_CASE (MAX_FILE_SIZE)

**2. Method:**
- Một method chỉ làm một việc
- Tên method phải mô tả rõ ràng
- Tối đa 20-30 dòng
- Tránh nested quá sâu (max 3 cấp)

**3. Comment:**
- Comment giải thích "Why", không giải thích "What"
- Code tốt không cần nhiều comment
- Cập nhật comment khi sửa code

**4. Exception:**
- Throw exception cụ thể, không throw Exception chung chung
- Catch exception ở tầng cao nhất (Controller/GlobalHandler)
- Log exception với đầy đủ thông tin

---

## 📊 PHẦN 9: TEST TRỰC TIẾP

### 9.1. Test Cases Quan Trọng

**TC1: Test Đăng Ký Với Username Đã Tồn Tại**
```
Bước 1: Đăng ký user "testuser" (thành công)
Bước 2: Đăng ký lại "testuser" với email khác
Expected: Lỗi "Username đã tồn tại"
Actual: ?
```

**TC2: Test Thêm Thuốc Với Mã Trùng**
```
Bước 1: Thêm thuốc mã "MED001" (thành công)
Bước 2: Thêm thuốc mã "MED001" với tên khác
Expected: Lỗi "Mã thuốc đã tồn tại"
Actual: ?
```

**TC3: Test Xóa Thuốc Không Tồn Tại**
```
Bước 1: DELETE /api/medicines/99999
Expected: 404 Not Found
Actual: ?
```

**TC4: Test Đăng Nhập Với Password Sai**
```
Bước 1: Đăng nhập với password sai 3 lần
Expected: Lỗi "Sai username hoặc password"
Actual: ?
```

**TC5: Test API Không Có Token**
```
Bước 1: GET /api/medicines (không gửi token)
Expected: 401 Unauthorized
Actual: ?
```

---

## 🎯 PHẦN 10: TỔNG KẾT

### 10.1. Điểm Mạnh Của Hệ Thống

✅ **Architecture:**
- Frontend: Flutter (đa nền tảng)
- Backend: Spring Boot (robust, scalable)
- Database: PostgreSQL (reliable)
- Clean Architecture: tách biệt concerns

✅ **Security:**
- JWT authentication
- BCrypt password hashing
- Input validation
- SQL injection prevention
- Authorization với roles

✅ **User Experience:**
- UI đẹp, dễ sử dụng
- Loading states
- Error handling tốt
- Confirmation dialogs

✅ **Code Quality:**
- Clean code
- Exception handling
- Transaction management
- Logging

---

### 10.2. Khả Năng Mở Rộng

🚀 **Phase 2:**
- Thêm module Khách hàng
- Thêm module Đơn hàng (Bán thuốc)
- Thêm module Nhà cung cấp
- Thêm module Nhập hàng

🚀 **Phase 3:**
- Báo cáo thống kê (Dashboard)
- Export Excel, PDF
- Notification system
- Chat support

🚀 **Phase 4:**
- Mobile app (iOS, Android)
- Web admin panel
- Multi-language
- Dark mode

---

## 📌 KẾT LUẬN

Hệ thống **Quản lý Nhà thuốc** đã được xây dựng với:
- ✅ **2 module chính**: User Management, Medicine Management
- ✅ **8 màn hình**
- ✅ **9 chức năng (Use Cases)**
- ✅ **Bảo mật tốt** với JWT và BCrypt
- ✅ **Validation đầy đủ**
- ✅ **Code clean, dễ maintain**
- ✅ **Có thể mở rộng**

Đây là nền tảng vững chắc để phát triển thêm các module phức tạp hơn trong tương lai.

---

**Chúc bạn báo cáo thành công! 🎉**

