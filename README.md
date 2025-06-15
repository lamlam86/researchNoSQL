
# 🛡️ Nghiên cứu về NoSQL Injection

![NoSQL Injection Example](https://hackmd.io/_uploads/B1yuT4YXlx.png)

---

## 📌 Tổng quan

**NoSQL Injection** là hình thức tấn công xảy ra khi kẻ tấn công chèn dữ liệu độc hại vào truy vấn cơ sở dữ liệu NoSQL như MongoDB. Khác với SQL truyền thống, NoSQL không sử dụng ngôn ngữ truy vấn chuẩn mà thay vào đó dùng cú pháp như JSON. Điều này dẫn đến các kiểu khai thác đặc thù, nhất là qua các toán tử như:

- `$ne`: không bằng
- `$gt`: lớn hơn
- `$regex`: biểu thức chính quy
- `$in`: nằm trong tập hợp

Nếu không lọc đầu vào cẩn thận, truy vấn dễ bị thao túng, dẫn tới rò rỉ dữ liệu hoặc bỏ qua xác thực.

---

## ⚙️ Ví dụ minh họa

Một ứng dụng web cho phép người dùng nhập giá để tìm sản phẩm:

```js
db.products.find({ "price": userInput })
```

Người dùng hợp lệ nhập `100`, thì truy vấn là:

```js
db.products.find({ "price": 100 })
```

Tuy nhiên, kẻ tấn công nhập:

```json
{ "$gt": 0 }
```

Truy vấn bị thay đổi thành:

```js
db.products.find({ "price": { "$gt": 0 } })
```

➡️ Kết quả: Tất cả sản phẩm có giá lớn hơn 0 sẽ được trả về → **rò rỉ dữ liệu toàn bộ**.

---

## 💥 Tác hại của NoSQL Injection

1. **Bỏ qua xác thực**:
   - Ví dụ: đăng nhập bằng cách sử dụng payload `{ "username": { "$ne": null }, "password": { "$ne": null } }`
   - Kết quả: truy vấn trả về người dùng bất kỳ → bỏ qua xác thực.

2. **Trích xuất/chỉnh sửa dữ liệu**:
   - Kẻ tấn công có thể tìm kiếm hoặc sửa các tài liệu không thuộc quyền truy cập.

3. **Gây từ chối dịch vụ (DoS)**:
   - Truy vấn bị thao túng để xử lý lượng dữ liệu lớn, gây treo hệ thống.

4. **Thực thi mã độc (trong trường hợp kết hợp với mã JS nội tuyến)**:
   - Một số hệ thống cho phép chạy biểu thức hoặc JavaScript nội bộ có thể bị lợi dụng.

---

## 🧬 Đặc điểm của cơ sở dữ liệu NoSQL

- Không dùng bảng quan hệ như SQL
- Truy vấn thường sử dụng JSON hoặc cú pháp đặc thù
- Không có chuẩn chung → dễ cấu hình sai
- Dữ liệu thường linh hoạt, không có ràng buộc → dễ bị thao túng

---

## 🔍 Các kiểu tấn công NoSQL Injection

### 1. Syntax Injection

- Tương tự SQL Injection
- Kẻ tấn công phá vỡ cấu trúc JSON để chèn thêm dữ liệu
- Ví dụ: tạo chuỗi JSON không hợp lệ để ép hệ thống sinh lỗi hoặc thực thi truy vấn không mong muốn

### 2. Operator Injection

- Sử dụng các toán tử truy vấn để điều khiển kết quả
- Ví dụ:
  - `$ne`: bỏ qua xác thực bằng cách kiểm tra `"password": { "$ne": null }`
  - `$regex`: dò tìm tài khoản bằng biểu thức chính quy như `"username": { "$regex": ".*" }`

---

## ✅ Cách phòng chống NoSQL Injection

- ❌ **Không bao giờ nhúng trực tiếp đầu vào người dùng vào truy vấn**
- ✅ **Sử dụng validation mạnh mẽ**:
  - Kiểm tra kiểu dữ liệu (chỉ nhận string/số, không nhận object)
  - Không cho phép nhập trực tiếp JSON nếu không xử lý kỹ

- ✅ **Sử dụng các thư viện truy vấn an toàn**:
  - ODM/ORM như Mongoose (MongoDB), không nên xây chuỗi truy vấn thủ công

- ✅ **Hạn chế quyền truy cập**:
  - Chỉ cấp quyền cần thiết cho tài khoản kết nối database

- ✅ **Log và giám sát**:
  - Theo dõi truy vấn bất thường, cảnh báo sớm khi có hành vi lạ

---

## 📚 Tham khảo thêm

- MongoDB Security Best Practices: https://www.mongodb.com/security
- OWASP NoSQL Injection: https://owasp.org/www-community/attacks/NoSQL_Injection
- HackTricks NoSQL Injection: https://book.hacktricks.xyz/pentesting-web/nosql-injection

---

> ⚠️ NoSQL rất mạnh mẽ và linh hoạt, nhưng cũng cực kỳ dễ bị khai thác nếu không có cơ chế kiểm tra và bảo vệ đầu vào chặt chẽ. Hãy kiểm soát mọi dữ liệu mà người dùng nhập vào!
