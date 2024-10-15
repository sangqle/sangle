---
author: Sang Le
pubDatetime: 2022-09-23T15:22:00Z
modDatetime: 2023-12-21T09:12:47.400Z
title: IOC (Inversion of Control) and DI Explained with Easy-to-Understand Examples
slug: ioc-di
featured: true
draft: false
tags:
  - docs
description:
  Some rules & recommendations for creating or adding new posts using AstroPaper
  theme.
---

**Giải Thích IoC (Inversion of Control) Bằng Ví Dụ Dễ Hiểu**

---

### **Inversion of Control (IoC) Là Gì?**

Inversion of Control (Đảo ngược điều khiển) là một nguyên tắc thiết kế trong đó luồng điều khiển của một chương trình được "đảo ngược" so với cách thông thường. Thay vì chính bạn kiểm soát luồng thực thi của chương trình, bạn để cho framework hoặc container kiểm soát luồng này, và framework sẽ gọi đến mã của bạn khi cần thiết.

---

### **Ví Dụ Thực Tiễn Về IoC**

#### **1. Ví Dụ Trong Đời Sống: Nhà Hàng Và Đầu Bếp**

- **Cách Truyền Thống (Không Có IoC):**

  Bạn muốn ăn một món ăn, vì vậy bạn vào bếp và tự mình nấu ăn. Bạn kiểm soát toàn bộ quá trình: chuẩn bị nguyên liệu, nấu nướng, và dọn dẹp.

- **Với IoC:**

  Bạn đến một nhà hàng và gọi món. Ở đây, bạn không kiểm soát quá trình nấu nướng nữa. Thay vào đó, nhà hàng (framework) sẽ đảm nhận việc đó. Bạn chỉ cần gọi món (cung cấp thông tin cần thiết), và đầu bếp (framework) sẽ gọi đến món ăn (mã của bạn) và phục vụ bạn.

#### **2. Ví Dụ Trong Lập Trình: Event Listener**

- **Cách Truyền Thống (Không Có IoC):**

  Bạn viết một chương trình và liên tục kiểm tra xem người dùng có nhấn nút không (polling). Bạn kiểm soát luồng thực thi và chủ động hỏi hệ thống về sự kiện.

- **Với IoC:**

  Bạn đăng ký một Event Listener với framework (ví dụ: GUI framework). Khi người dùng nhấn nút, framework sẽ gọi đến phương thức của bạn để xử lý sự kiện. Bạn không kiểm soát luồng chính nữa; thay vào đó, framework điều khiển và gọi mã của bạn khi cần.

#### **3. Ví Dụ Trong Web Development Với Spring Framework**

- **Cách Truyền Thống (Không Có IoC):**

  Bạn viết một ứng dụng Java mà trong đó bạn tạo các đối tượng, quản lý chúng, và gọi trực tiếp các phương thức cần thiết. Bạn kiểm soát việc khởi tạo và quản lý các thành phần.

- **Với IoC:**

  Trong Spring Framework, bạn định nghĩa các bean và phụ thuộc của chúng trong cấu hình (XML, Java Config, hoặc Annotation). Spring IoC Container sẽ tạo và quản lý các bean này. Khi ứng dụng chạy, Spring sẽ gọi đến các bean của bạn khi cần thiết (ví dụ: khi có một HTTP request đến controller).

---

### **Minh Họa Cụ Thể Với Mã Nguồn**

#### **Không Sử Dụng IoC:**

```java
public class MainApp {
    public static void main(String[] args) {
        UserService userService = new UserService();
        userService.process();
    }
}

public class UserService {
    private UserRepository userRepository = new UserRepository();

    public void process() {
        // Thực hiện logic
        userRepository.save();
    }
}

public class UserRepository {
    public void save() {
        System.out.println("Saving user...");
    }
}
```

- **Điểm Chú Ý:**
  - `UserService` tự tạo một instance của `UserRepository`.
  - `MainApp` kiểm soát luồng thực thi và khởi tạo mọi thứ.
  - Sự phụ thuộc được quản lý thủ công và mã của bạn kiểm soát mọi thứ.

#### **Sử Dụng IoC Với Spring Framework:**

```java
// Lớp MainApp không còn cần phải khởi tạo các đối tượng nữa
@SpringBootApplication
public class MainApp {
    public static void main(String[] args) {
        SpringApplication.run(MainApp.class, args);
    }
}

// UserService không tự tạo UserRepository nữa
@Service
public class UserService {

    private final UserRepository userRepository;

    // Phụ thuộc được "tiêm" vào qua constructor
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void process() {
        userRepository.save();
    }
}

@Repository
public class UserRepository {
    public void save() {
        System.out.println("Saving user...");
    }
}
```

- **Điểm Chú Ý:**
  - `MainApp` khởi động ứng dụng bằng cách gọi `SpringApplication.run()`. Sau đó, Spring sẽ quản lý luồng thực thi.
  - `UserService` không tự tạo `UserRepository` nữa. Thay vào đó, Spring sẽ tiêm `UserRepository` vào `UserService`.
  - Bạn chỉ cần khai báo các bean (với @Service, @Repository), và Spring sẽ tạo và quản lý chúng.
  - Khi có một yêu cầu HTTP đến, Spring sẽ gọi đến các controller hoặc service tương ứng.

---

### **Tóm Tắt Lại:**

- **Inversion of Control (IoC):**
  - **Đảo ngược việc kiểm soát luồng chương trình** từ chính bạn sang framework.
  - **Bạn không còn phải quản lý chi tiết việc khởi tạo và gọi các đối tượng**; framework sẽ làm điều đó cho bạn.
  - **Lợi ích:**
    - Giảm sự kết nối chặt chẽ giữa các thành phần.
    - Dễ dàng thay đổi và mở rộng ứng dụng.
    - Tập trung vào logic nghiệp vụ thay vì quản lý luồng thực thi.

- **Trong Spring Framework:**
  - **IoC Container** chịu trách nhiệm khởi tạo và quản lý các bean.
  - **Bạn định nghĩa các bean và phụ thuộc**, còn việc tạo và kết nối chúng do Spring quản lý.
  - **Luồng thực thi do Spring điều khiển**, ví dụ như xử lý các yêu cầu HTTP và gọi đến các phương thức controller của bạn.

---

### **Ví Dụ Khác: Plugin System**

- **Không Có IoC:**

  Ứng dụng chính biết rõ về tất cả các plugin và tự mình gọi đến chúng khi cần.

- **Với IoC:**

  Ứng dụng chính cung cấp các điểm mở rộng (extension points). Các plugin đăng ký với ứng dụng, và khi một sự kiện xảy ra, ứng dụng sẽ gọi đến các plugin tương ứng. Ứng dụng chính không cần biết chi tiết về các plugin.

---

### **Kết Luận:**

- IoC giúp bạn **giảm tải việc quản lý luồng điều khiển và phụ thuộc**.
- Bạn **tập trung vào việc viết logic nghiệp vụ**, còn framework sẽ lo phần còn lại.
- Việc hiểu IoC giúp bạn **sử dụng hiệu quả các framework hiện đại** như Spring, và xây dựng ứng dụng một cách linh hoạt và dễ bảo trì hơn.