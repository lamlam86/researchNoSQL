<h1 align="center">🛡️ Nghiên cứu về NoSQL Injection</h1>

<p align="center">
  <img src="https://hackmd.io/_uploads/B1yuT4YXlx.png" alt="NoSQL Injection Example" width="500">
</p>

---

## 📌 Tổng quan

<blockquote>
  <strong>NoSQL Injection</strong> (tiêm NoSQL) xảy ra khi kẻ tấn công chèn đầu vào độc hại để điều khiển truy vấn cơ sở dữ liệu NoSQL (ví dụ: MongoDB). Không giống SQL truyền thống, NoSQL sử dụng cú pháp khác (thường là JSON), khiến việc tiêm trở nên nguy hiểm hơn nếu không được lọc kỹ.
</blockquote>

---

## ⚙️ Ví dụ minh họa

Giả sử một ứng dụng web có chức năng tìm kiếm sản phẩm dựa trên giá do người dùng nhập vào:

```javascript
db.products.find({ "price": userInput })
