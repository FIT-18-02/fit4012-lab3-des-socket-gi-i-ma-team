# Threat Model - Lab 3

## Thông tin nhóm
- Thành viên 1: [Điền họ tên] - MSSV: [Điền MSSV] - phụ trách Sender
- Thành viên 2: [Điền họ tên] - MSSV: [Điền MSSV] - phụ trách Receiver

## Scope
Threat model này áp dụng cho chương trình Sender/Receiver trong phạm vi bài lab. Hệ thống chạy qua TCP socket, trong đó Sender gửi packet gồm DES key, IV, ciphertext length và ciphertext cho Receiver. Thiết kế này dùng để học cách mã hoá, đóng gói và giải mã dữ liệu, không dùng để bảo vệ dữ liệu thật.

## Assets
Các tài sản cần bảo vệ gồm bản tin gốc do người dùng nhập, DES key 8 byte, IV 8 byte, ciphertext, tính toàn vẹn của packet trên đường truyền và tính đúng đắn của kết quả giải mã tại Receiver. Ngoài ra, log demo cũng cần tránh chứa dữ liệu cá nhân hoặc dữ liệu nhạy cảm vì log có thể được nộp hoặc chia sẻ trong lớp học.

## Attacker model
Attacker được giả định có khả năng quan sát traffic trong cùng mạng nội bộ, ví dụ nghe lén kết nối TCP giữa Sender và Receiver. Attacker cũng có thể thử sửa đổi packet, gửi lại packet cũ hoặc tạo kết nối giả tới Receiver nếu biết host và port đang lắng nghe. Trong phạm vi lab, attacker không cần chiếm quyền máy Sender/Receiver; chỉ cần truy cập được luồng mạng hoặc có thể gửi dữ liệu tới port của Receiver là đã gây rủi ro.

## Threats
1. **Eavesdropping**: Sender gửi DES key và IV ở dạng plaintext trong cùng packet với ciphertext. Nếu attacker nghe lén được traffic, attacker có đủ key, IV và ciphertext để giải mã bản tin gốc.
2. **Tampering**: Attacker có thể thay đổi byte trong header hoặc ciphertext. Receiver có thể giải mã ra dữ liệu sai, lỗi padding hoặc xử lý thông tin không đáng tin cậy nếu không có cơ chế xác thực toàn vẹn.
3. **Man-in-the-middle**: Attacker đứng giữa Sender và Receiver có thể chặn, sửa hoặc thay thế packet trước khi Receiver nhận được.
4. **Replay attack**: Attacker có thể gửi lại packet cũ vì hệ thống chưa có nonce, timestamp, sequence number hoặc cơ chế chống phát lại.
5. **Denial of service**: Attacker có thể kết nối tới Receiver rồi gửi thiếu dữ liệu hoặc gửi length bất thường để làm Receiver chờ, lỗi hoặc tiêu tốn tài nguyên.
6. **Log exposure**: Log demo có thể chứa key, IV, ciphertext hoặc bản tin gốc. Nếu dùng dữ liệu thật, log có thể làm lộ thông tin nhạy cảm.

## Mitigations
1. Không gửi key plaintext trong packet. Trong hệ thống thật nên dùng TLS hoặc cơ chế trao đổi khoá an toàn như Diffie-Hellman có xác thực.
2. Thay DES bằng thuật toán hiện đại hơn như AES. DES chỉ có key 56-bit hiệu dụng nên không phù hợp để bảo vệ dữ liệu thực tế.
3. Bổ sung xác thực toàn vẹn bằng HMAC hoặc dùng chế độ AEAD như AES-GCM để Receiver phát hiện packet bị sửa đổi.
4. Thêm nonce, timestamp hoặc sequence number để giảm rủi ro replay attack.
5. Giới hạn kích thước ciphertext, đặt socket timeout và kiểm tra `length` trước khi nhận dữ liệu để giảm rủi ro denial of service.
6. Chỉ chạy demo trong môi trường học tập, localhost hoặc mạng nội bộ được phép; không dùng dữ liệu thật hoặc dữ liệu nhạy cảm.
7. Khi nộp log, chỉ dùng message demo vô hại và không đưa thông tin cá nhân vào bản tin.

## Residual risks
Ngay cả khi thêm timeout và kiểm tra length, mô hình hiện tại vẫn còn rủi ro lớn vì key được gửi cùng packet và DES không còn đủ mạnh cho môi trường thực tế. Bài lab phù hợp để học luồng mã hoá/gửi/nhận qua socket, nhưng không nên trình bày như một giải pháp bảo mật hoàn chỉnh. Nếu cần bảo vệ dữ liệu thật, nhóm cần chuyển sang giao thức đã được kiểm chứng như TLS và dùng thuật toán mã hoá hiện đại có xác thực toàn vẹn.
