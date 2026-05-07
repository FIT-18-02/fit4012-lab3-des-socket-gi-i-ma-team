# Sender/Receiver demo notes

## Mục tiêu demo
Demo cần chứng minh được Sender mã hoá bản tin, gửi packet qua socket và Receiver giải mã lại đúng bản tin gốc.

## Thứ tự chạy
Terminal 1 chạy Receiver trước:

```bash
RECEIVER_HOST=127.0.0.1 RECEIVER_PORT=6001 RECEIVER_LOG_FILE=logs/01-happy-path-receiver.txt python receiver.py
```

Terminal 2 chạy Sender:

```bash
SERVER_IP=127.0.0.1 SERVER_PORT=6001 MESSAGE="Xin chao FIT4012 - Sender Receiver demo" SENDER_LOG_FILE=logs/01-happy-path-sender.txt python sender.py
```

Có thể chạy nhanh bằng script:

```bash
bash demo_local.sh 6001 "Xin chao FIT4012 - Sender Receiver demo"
```

## Thành viên 1 trình bày Sender
- Sender lấy message từ bàn phím hoặc biến môi trường `MESSAGE`.
- Sender sinh DES key 8 byte và IV 8 byte.
- Sender dùng DES-CBC và PKCS#7 padding để mã hoá message.
- Sender tạo packet gồm `key + IV + length + ciphertext`.
- Sender dùng `sendall()` để gửi toàn bộ packet sang Receiver.
- Sender ghi log key, IV và ciphertext để minh chứng demo.

## Thành viên 2 trình bày Receiver
- Receiver mở TCP server socket và lắng nghe kết nối.
- Receiver nhận header 20 byte.
- Header gồm key 8 byte, IV 8 byte và length 4 byte.
- Receiver dùng `recv_exact()` để nhận đủ ciphertext theo length.
- Receiver giải mã DES-CBC, bỏ padding và in bản tin gốc.
- Receiver ghi log bản tin gốc để minh chứng demo.

## Câu trả lời threat model nên nói
Thiết kế hiện tại không an toàn trong thực tế vì key và IV được gửi plaintext cùng ciphertext. Nếu attacker nghe lén được traffic, attacker có thể lấy key, IV, ciphertext và giải mã toàn bộ bản tin.

## Hướng cải tiến
- Dùng TLS hoặc key exchange an toàn thay vì gửi key plaintext.
- Thay DES bằng AES.
- Dùng HMAC hoặc AES-GCM để kiểm tra toàn vẹn.
- Thêm nonce/timestamp để chống replay.
- Đặt timeout và giới hạn length để giảm DoS.
