-- Cập nhật giá trị minimumStock cho các bản ghi có giá trị null
UPDATE medicines
SET minimum_stock = 10
WHERE minimum_stock IS NULL;

-- Đảm bảo cột minimum_stock có giá trị mặc định cho các bản ghi mới
ALTER TABLE medicines
ALTER COLUMN minimum_stock SET DEFAULT 10;

