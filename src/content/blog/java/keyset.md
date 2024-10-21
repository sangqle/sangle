---
author: Sang Le
pubDatetime: 2024-09-23T15:22:00Z
modDatetime: 2024-10-21T09:12:47.400Z
title: IOC (Inversion of Control) and DI Explained with Easy-to-Understand Examples
slug: keyset
featured: true
draft: true
tags:
  - docs
  - java
  - spring
  - ioc
  - di
description:
  Learn what IoC (Inversion of Control) and DI (Dependency Injection) are, and how they work with real-world examples. Understand the benefits of IoC and how it's used in modern frameworks like Spring.
---

### Keyset Pagination (Truy vấn theo Last ID) – Giải Pháp Tối Ưu Cho Dữ Liệu Lớn

Khi làm việc với các cơ sở dữ liệu lớn, vấn đề truy vấn hiệu quả là một thách thức không hề nhỏ. Đặc biệt là khi bảng dữ liệu của bạn có tới hàng triệu bản ghi, việc sử dụng phân trang truyền thống bằng `OFFSET` sẽ khiến mọi thứ trở nên chậm chạp. Để giải quyết tình huống này, **Keyset Pagination** (hay truy vấn theo Last ID) là một kỹ thuật rất hữu ích giúp tối ưu hóa hiệu suất truy vấn mà mình muốn chia sẻ với các bạn.

### Vấn đề với Phân trang Truyền thống (OFFSET)

Khi chúng ta muốn truy vấn dữ liệu phân trang, phương pháp truyền thống là sử dụng `LIMIT` kết hợp với `OFFSET`. Ví dụ, để lấy 50 bản ghi đầu tiên, mình sẽ thực hiện câu lệnh SQL như sau:

```sql
SELECT * FROM my_table WHERE type = 'bank' AND isDeleted = 0 ORDER BY id LIMIT 50 OFFSET 0;
```

Nếu muốn lấy 50 bản ghi tiếp theo, mình sẽ tăng giá trị `OFFSET`:

```sql
SELECT * FROM my_table WHERE type = 'bank' AND isDeleted = 0 ORDER BY id LIMIT 50 OFFSET 50;
```

Vấn đề là khi bảng dữ liệu càng lớn, việc sử dụng `OFFSET` khiến cơ sở dữ liệu phải bỏ qua một lượng bản ghi nhất định trước khi trả về kết quả. Khi bảng của bạn có hàng chục triệu bản ghi, như mình đã thử nghiệm thực tế với 70 triệu bản ghi, hiệu suất của cách làm này giảm đi rất nhanh.

### Giải pháp: Keyset Pagination (Truy vấn theo Last ID)

**Keyset Pagination** sẽ giúp cải thiện hiệu suất truy vấn khi làm việc với dữ liệu lớn. Thay vì sử dụng `OFFSET`, kỹ thuật này dựa vào giá trị `ID` của bản ghi cuối cùng từ lần truy vấn trước đó để tiếp tục truy vấn các bản ghi tiếp theo. Phương pháp này không yêu cầu cơ sở dữ liệu phải quét qua các bản ghi không cần thiết, giúp tiết kiệm rất nhiều thời gian.

### Cách thức hoạt động của Keyset Pagination

1. **Lấy một số lượng bản ghi nhất định** (ví dụ 50 bản ghi đầu tiên):
   Đầu tiên, chúng ta lấy 50 bản ghi được sắp xếp theo thứ tự tăng dần của cột `ID` hoặc một khóa chính nào đó.

   ```sql
   SELECT * FROM my_table WHERE type = 'bank' AND isDeleted = 0 ORDER BY id LIMIT 50;
   ```

2. **Lưu giá trị `ID` của bản ghi cuối cùng**:
   Sau khi có kết quả, mình sẽ lưu lại giá trị của `ID` từ bản ghi cuối cùng để dùng cho lần truy vấn kế tiếp.

3. **Truy vấn các bản ghi tiếp theo dựa trên `lastId`**:
   Lần tiếp theo, thay vì sử dụng `OFFSET`, mình sẽ chỉ truy vấn những bản ghi có `ID` lớn hơn giá trị `ID` cuối cùng từ lần truy vấn trước.

   ```sql
   SELECT * FROM my_table WHERE type = 'bank' AND isDeleted = 0 AND id > lastId ORDER BY id LIMIT 50;
   ```

Bằng cách này, cơ sở dữ liệu không cần phải quét toàn bộ các bản ghi để bỏ qua, giúp tăng tốc độ truy vấn đáng kể.

### Demo Code: Phân Trang Truyền thống vs Keyset Pagination

#### Phân trang Truyền thống (OFFSET)

```sql
-- Lấy 50 bản ghi đầu tiên
SELECT * FROM my_table WHERE type = 'bank' AND isDeleted = 0 ORDER BY id LIMIT 50 OFFSET 0;

-- Lấy 50 bản ghi tiếp theo
SELECT * FROM my_table WHERE type = 'bank' AND isDeleted = 0 ORDER BY id LIMIT 50 OFFSET 50;

-- Lấy thêm 50 bản ghi nữa
SELECT * FROM my_table WHERE type = 'bank' AND isDeleted = 0 ORDER BY id LIMIT 50 OFFSET 100;
```

Nhược điểm:
- Khi `OFFSET` tăng lên, hiệu suất giảm đi vì cơ sở dữ liệu phải bỏ qua nhiều bản ghi hơn.
- Không hiệu quả khi bảng dữ liệu lớn, như trong thử nghiệm của mình với 70 triệu bản ghi.

#### Keyset Pagination (Truy vấn theo Last ID)

```sql
-- Lấy 50 bản ghi đầu tiên
SELECT * FROM my_table WHERE type = 'bank' AND isDeleted = 0 ORDER BY id LIMIT 50;

-- Lấy 50 bản ghi tiếp theo dựa trên lastId (ID cuối cùng của kết quả trước)
SELECT * FROM my_table WHERE type = 'bank' AND isDeleted = 0 AND id > lastId ORDER BY id LIMIT 50;

-- Lặp lại cho các bản ghi tiếp theo
SELECT * FROM my_table WHERE type = 'bank' AND isDeleted = 0 AND id > lastId ORDER BY id LIMIT 50;
```

Ưu điểm:
- Hiệu suất ổn định ngay cả khi làm việc với bảng dữ liệu lớn.
- Truy vấn nhanh hơn vì không cần quét lại các bản ghi đã bỏ qua.

### Thử nghiệm thực tế

Trong quá trình thử nghiệm với bảng có **70 triệu bản ghi**, mình nhận thấy **Keyset Pagination** vượt trội so với phương pháp dùng `OFFSET`. Khi dữ liệu lớn dần, phương pháp `OFFSET` chậm hẳn đi, trong khi Keyset Pagination vẫn giữ được tốc độ ổn định. Đây là kết quả rất ấn tượng khi xử lý những tập dữ liệu lớn trong môi trường sản xuất.

### Khi nào nên dùng Keyset Pagination?

- Khi cần phân trang dữ liệu lớn.
- Khi muốn tăng tốc độ truy vấn và tránh việc cơ sở dữ liệu phải quét qua nhiều bản ghi không cần thiết.
- Khi cột `ID` hoặc khóa chính của bảng là duy nhất và liên tục.

### Kết luận

**Keyset Pagination** là một kỹ thuật cực kỳ hiệu quả khi làm việc với dữ liệu lớn. Bằng cách sử dụng giá trị `ID` để phân trang thay vì dựa vào `OFFSET`, kỹ thuật này giúp chúng ta giữ được hiệu suất ổn định và nhanh chóng ngay cả khi làm việc với bảng dữ liệu lớn như mình đã thử nghiệm với 70 triệu bản ghi. Nếu bạn đang gặp vấn đề với hiệu suất khi truy vấn dữ liệu lớn, hãy thử áp dụng kỹ thuật này, chắc chắn bạn sẽ thấy sự khác biệt đáng kể!