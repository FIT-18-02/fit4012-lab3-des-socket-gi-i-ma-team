# Report 1 page - Lab 3

## Thông tin nhóm
- Thành viên 1: Hồ Khắc Sơn - MSSV: 1871020503- phụ trách Sender
- Thành viên 2: Vũ Khánh Hùng - MSSV: 1871020266 - phụ trách Receiver

Bản nộp này được chuẩn bị theo mô hình nhóm có 2 người. Thông tin cá nhân để trống theo yêu cầu hiện tại và có thể điền lại trước khi nộp nếu cần.

## Mục tiêu
Bài lab triển khai hệ thống gửi và nhận dữ liệu mã hoá DES qua TCP socket. Mục tiêu kỹ thuật là hiểu cách Sender mã hoá bản tin bằng DES-CBC, đóng gói `key`, `IV`, độ dài ciphertext và ciphertext để gửi sang Receiver. Ở phía Receiver, mục tiêu là nhận đúng packet, tách header, giải mã ciphertext và hiển thị lại bản tin gốc. Bài lab cũng giúp hiểu vai trò của PKCS#7 padding, IV, header độ dài và cơ chế nhận đủ byte qua socket. Về bảo mật, bài lab yêu cầu nhận diện điểm yếu của mô hình gửi key plaintext và đề xuất hướng cải tiến an toàn hơn.

## Phân công thực hiện
Thành viên 1 phụ trách phần Sender. Sender nhận input từ bàn phím hoặc biến môi trường `MESSAGE`, sinh DES key 8 byte và IV 8 byte, mã hoá bản tin bằng DES-CBC + PKCS#7, tạo packet theo định dạng `key + IV + length + ciphertext`, gửi packet bằng TCP socket và lưu log phía gửi.

Thành viên 2 phụ trách phần Receiver. Receiver mở TCP server, lắng nghe kết nối, nhận header 20 byte, parse `key`, `IV`, `ciphertext length`, nhận đủ ciphertext, giải mã DES-CBC, bỏ padding, decode UTF-8, in bản tin gốc và lưu log phía nhận.

Cả hai thành viên cùng thống nhất packet format, chạy test, tạo logs minh chứng, viết report, threat model, peer review và chuẩn bị phần giải thích demo.

## Cách làm
Các hàm dùng chung được đặt trong `des_socket_utils.py`. Hàm `pad()` và `unpad()` xử lý PKCS#7 padding theo block size 8 byte của DES. Hàm `encrypt_des_cbc()` sinh hoặc nhận key/IV, sau đó mã hoá bản tin bằng DES-CBC. Hàm `build_packet()` nối key, IV, length 4 byte dạng network byte order và ciphertext thành một packet hoàn chỉnh.

Ở chiều gửi, `sender.py` đọc message, gọi hàm mã hoá, tạo packet rồi dùng `sendall()` để đảm bảo toàn bộ packet được gửi qua TCP. Ở chiều nhận, `receiver.py` dùng `recv_exact()` để đọc đúng số byte cần thiết, `parse_header()` để tách header và `decrypt_des_cbc()` để giải mã. Việc dùng `recv_exact()` rất quan trọng vì TCP không bảo toàn ranh giới message; nếu chỉ gọi `recv()` một lần thì có thể nhận thiếu dữ liệu.

## Kết quả
Hệ thống đã chạy được luồng happy path giữa Sender và Receiver trên localhost. Ví dụ demo sử dụng message `Xin chao FIT4012 - Sender Receiver demo`. Sender mã hoá bản tin, in key/IV/ciphertext và ghi log vào `logs/01-happy-path-sender.txt`. Receiver nhận packet, giải mã thành công và ghi bản tin gốc vào `logs/01-happy-path-receiver.txt`.

Bộ kiểm thử tự động gồm kiểm thử padding/header, kiểm thử contract packet format, kiểm thử local socket, negative test cho tamper và negative test cho wrong key. Các kiểm thử giúp xác nhận hai chương trình tương thích với nhau và các trường hợp lỗi cơ bản được xử lý.

## Kết luận
Qua bài lab, nhóm hiểu rõ hơn cách TCP socket truyền dữ liệu theo byte stream và vì sao Receiver cần cơ chế nhận đủ byte. Nhóm cũng nắm được quy trình DES-CBC cần key, IV và padding để xử lý bản tin có độ dài bất kỳ.

Về bảo mật, thiết kế hiện tại không an toàn trong thực tế vì key và IV được gửi plaintext cùng ciphertext. Nếu attacker nghe lén traffic, attacker có thể lấy key, IV, ciphertext và giải mã toàn bộ bản tin. Nếu triển khai thật, hệ thống cần dùng TLS hoặc cơ chế trao đổi khoá an toàn, thay DES bằng AES, đồng thời bổ sung kiểm tra toàn vẹn bằng HMAC hoặc dùng AEAD như AES-GCM.
