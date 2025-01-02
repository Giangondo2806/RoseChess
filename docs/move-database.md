# Thiết kế database


**1. Bảng **BaseMoves** **(Nước đi cơ sở):****

* **base\_move\_id** **(INT, PRIMARY KEY, AUTO\_INCREMENT): ID duy nhất cho mỗi nước đi cơ sở.**
* **notation** **(VARCHAR(255)): Ký hiệu của nước đi (ví dụ: 'e2e4', 'd7d5').**
* **evaluation** **(INT): Đánh giá nước đi (có thể là giá trị trung bình hoặc từ một engine cờ vua mạnh).**
* **fen** **(VARCHAR(255)): Chuỗi FEN mô tả trạng thái bàn cờ** **sau** **khi thực hiện nước đi này.**

**2. Bảng** **Games** **(Ván cờ):**

* **game\_id** **(INT, PRIMARY KEY, AUTO\_INCREMENT): ID duy nhất cho mỗi ván cờ.**
* **start\_time** **(DATETIME): Thời gian bắt đầu ván cờ.**
* **end\_time** **(DATETIME): Thời gian kết thúc ván cờ.**
* **white\_player** **(VARCHAR(255)): Tên người chơi quân trắng.**
* **black\_player** **(VARCHAR(255)): Tên người chơi quân đen.**
* **result** **(ENUM('1-0', '0-1', '1/2-1/2', '\*')) : Kết quả ván cờ.**

**3. Bảng** **GameMoves** **(Nước đi của ván cờ - Tên mới để tránh trùng):**

* **game\_move\_id** **(INT, PRIMARY KEY, AUTO\_INCREMENT): ID duy nhất cho mỗi nước đi trong một ván cờ cụ thể.**
* **game\_id** **(INT, FOREIGN KEY referencing** **Games**.**game\_id**): ID của ván cờ mà nước đi này thuộc về.
* **move\_number** **(INT): Số thứ tự của nước đi trong ván cờ.**
* **base\_move\_id** **(INT, FOREIGN KEY referencing** **BaseMoves**.**base\_move\_id**): ID của nước đi cơ sở tương ứng trong bảng **BaseMoves**.
* **parent\_move\_id** **(INT, NULL, FOREIGN KEY referencing** **GameMoves**.**game\_move\_id**): ID của nước đi cha trong ván cờ này. **NULL** **nếu là nước đi đầu tiên của nhánh.**

**Mối quan hệ:**

* **Games** **1:N** **GameMoves**: **Một ván cờ có nhiều nước đi.**
* **BaseMoves** **1:N** **GameMoves**: **Một nước đi cơ sở có thể xuất hiện trong nhiều ván cờ (nhiều** **GameMoves**).
* **GameMoves** **1:N** **GameMoves** **(đệ quy):** **Một nước đi có thể có nhiều nước đi con (tạo thành cây).**

**Giải thích:**

* **BaseMoves**: **Bảng này lưu trữ tất cả các nước đi riêng biệt, bao gồm ký hiệu, đánh giá và FEN. Mỗi nước đi chỉ được lưu trữ một lần duy nhất trong bảng này.**
* **Games**: **Bảng này không thay đổi, vẫn lưu thông tin chung về ván cờ.**
* **GameMoves**: **Bảng này đóng vai trò là bảng trung gian, liên kết giữa** **Games** **và** **BaseMoves**.

  * **base\_move\_id** **liên kết đến nước đi cơ sở trong bảng** **BaseMoves**.
  * **parent\_move\_id** **vẫn giữ nguyên chức năng tạo cấu trúc cây cho các nhánh trong ván cờ.**
