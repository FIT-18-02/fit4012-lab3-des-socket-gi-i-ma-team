[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/jjUQ5jLa)
# FIT4012 - Lab 3 - DES Socket Sender/Receiver

Repo này triển khai hệ thống gửi và nhận dữ liệu mã hoá DES qua TCP socket. Hệ thống gồm hai chương trình chính:

- `sender.py`: mã hoá bản tin bằng DES-CBC rồi gửi packet qua socket.
- `receiver.py`: nhận packet, giải mã DES-CBC và hiển thị bản tin gốc.

Bài lab dùng mô hình `key + IV + length + ciphertext` để sinh viên hiểu rõ luồng mã hoá, đóng gói, truyền và giải mã dữ liệu. Thiết kế này phục vụ mục đích học tập, **không phải thiết kế bảo mật an toàn để dùng trong thực tế**, vì key đang được gửi plaintext cùng ciphertext.

## Team members
- **Thành viên 1**: Hồ Khắc Sơn - MSSV: 1871020503 - phụ trách Sender
- **Thành viên 2**: Vũ Khánh Hùng- MSSV: 1871020266 - phụ trách Receiver

> Ghi chú: Bản này được chuẩn bị theo mô hình nhóm có **2 người**. Thông tin họ tên và MSSV để trống theo yêu cầu hiện tại; trước khi nộp chính thức, nhóm có thể điền lại nếu giảng viên yêu cầu.

## Branch plan
Bài này không bắt buộc phải tạo nhánh nếu chỉ nộp sản phẩm cuối cùng trên `main`. Tuy nhiên, nếu muốn thể hiện rõ quá trình làm nhóm, nhóm có thể dùng các nhánh sau:

- `feature/sender`: phần Sender, packet format, log phía gửi.
- `feature/receiver`: phần Receiver, parse header, decrypt, log phía nhận.
- `docs/report`: README, report, threat model, peer review.
- `main`: nhánh cuối cùng sau khi merge đầy đủ và chạy pass test.

Repo cuối cùng nên nộp từ `main` sau khi đã merge đủ Sender, Receiver, tài liệu, test và logs.

## Task division
- **Thành viên 1 - Sender**: nhận bản tin từ bàn phím hoặc biến môi trường `MESSAGE`, sinh DES key 8 byte và IV 8 byte, mã hoá bằng DES-CBC + PKCS#7, đóng gói packet theo định dạng `key + IV + length + ciphertext`, gửi packet qua TCP socket và lưu log phía gửi.
- **Thành viên 2 - Receiver**: mở TCP server socket, lắng nghe kết nối, nhận đúng 20 byte header, tách `key`, `IV`, `ciphertext length`, nhận đủ ciphertext, giải mã DES-CBC, bỏ padding PKCS#7, hiển thị bản tin gốc và lưu log phía nhận.
- **Phần làm chung**: thống nhất packet format, kiểm thử local sender/receiver, kiểm tra negative test cho tamper và wrong key, viết threat model, report, peer review, chuẩn bị demo và giải thích rủi ro bảo mật của mô hình gửi key plaintext.

## Demo roles
- **Demo Sender - Thành viên 1**: trình bày cách nhập message, sinh key/IV, mã hoá DES-CBC, tạo ciphertext, đóng gói packet và gửi sang Receiver.
- **Demo Receiver - Thành viên 2**: trình bày cách Receiver nhận header/ciphertext, parse packet, giải mã DES-CBC và in bản rõ.
- **Threat model và ethics - cả hai thành viên**: giải thích vì sao hệ thống chỉ dùng cho học tập, không dùng để bảo vệ dữ liệu thật; nêu hướng cải tiến như TLS, AES và HMAC/AEAD.

## Mục tiêu học tập
- Hiểu luồng hoạt động của hệ thống Sender/Receiver qua TCP socket.
- Mô tả được vai trò của DES key, IV, PKCS#7 padding và header độ dài.
- Cài đặt và chạy được hệ thống gửi/nhận dữ liệu mã hoá DES qua socket.
- Viết được threat model ngắn gọn cho hệ thống.
- Ghi nhận được hạn chế bảo mật của thiết kế hiện tại và nêu hướng cải tiến.

## Cấu trúc repo
- `sender.py`: tiến trình người gửi.
- `receiver.py`: tiến trình người nhận.
- `des_socket_utils.py`: hàm dùng chung cho pad/unpad, encrypt/decrypt, build/parse packet và nhận đủ byte.
- `tests/`: kiểm thử tự động.
- `logs/`: log minh chứng khi chạy demo.
- `report-1page.md`: báo cáo ngắn.
- `threat-model-1page.md`: threat model cho hệ thống.
- `peer-review-response.md`: ghi nhận góp ý và chỉnh sửa sau peer review.
- `BRANCH_AND_REPORT_GUIDE.md`: hướng dẫn tạo nhánh và mô tả nội dung từng report.
- `SENDER_RECEIVER_DEMO_NOTES.md`: ghi chú nhanh để demo cả hai phần.

## How to run
### 1) Cài môi trường
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 2) Chạy Receiver trước
Receiver cần chạy trước Sender để mở cổng lắng nghe:

```bash
python receiver.py
```

Có thể chỉ định host, port và log file:

```bash
RECEIVER_HOST=127.0.0.1 RECEIVER_PORT=6001 RECEIVER_LOG_FILE=logs/01-happy-path-receiver.txt python receiver.py
```

### 3) Chạy Sender
```bash
python sender.py
```

Sau đó nhập bản tin khi chương trình hỏi.

Có thể chạy nhanh bằng biến môi trường:

```bash
SERVER_IP=127.0.0.1 SERVER_PORT=6001 MESSAGE="Xin chao FIT4012 - Sender Receiver demo" SENDER_LOG_FILE=logs/01-happy-path-sender.txt python sender.py
```

### 4) Chạy demo local bằng script
```bash
bash demo_local.sh 6001 "Xin chao FIT4012 - Sender Receiver demo"
```

### 5) Chạy kiểm thử
```bash
pytest -q
bash .github/scripts/check_submission.sh
```

## Input / Output
### Input
- Sender nhận bản tin từ bàn phím hoặc từ biến môi trường `MESSAGE`.
- Receiver nhận packet qua TCP socket.

### Packet format
Packet được gửi theo thứ tự:

```text
8 bytes DES key | 8 bytes IV | 4 bytes ciphertext length | ciphertext
```

Receiver đọc đúng 20 byte header đầu tiên, sau đó dùng trường `ciphertext length` để đọc đủ ciphertext. Cách làm này quan trọng vì TCP là byte stream, một lần `recv()` không đảm bảo nhận đủ toàn bộ packet.

### Output
- Sender in ra thông báo gửi thành công, `Key`, `IV`, `Ciphertext`.
- Receiver in ra bản tin gốc sau giải mã, ví dụ:

```text
[+] Bản tin gốc: Xin chao FIT4012 - Sender Receiver demo
```

- Log chạy thật được lưu trong thư mục `logs/` để làm minh chứng nộp bài.

## Sender implementation notes
Phần Sender nằm trong `sender.py` và dùng các hàm hỗ trợ từ `des_socket_utils.py`:

- `get_message()`: lấy bản tin từ biến môi trường `MESSAGE` hoặc từ bàn phím.
- `encrypt_des_cbc(plain)`: sinh DES key, IV và mã hoá bản tin bằng DES-CBC.
- `build_packet(key, iv, cipher_bytes)`: tạo packet theo định dạng `key + IV + length + ciphertext`.
- `sendall(packet)`: gửi toàn bộ packet sang Receiver.
- `SENDER_LOG_FILE`: nếu biến môi trường này được đặt, Sender ghi log gồm key, IV và ciphertext.

## Receiver implementation notes
Phần Receiver nằm trong `receiver.py` và dùng các hàm hỗ trợ từ `des_socket_utils.py`:

- `recv_exact(conn, n)`: nhận đúng `n` byte từ socket, tránh trường hợp `recv()` chỉ trả về một phần dữ liệu.
- `parse_header(header)`: tách header 20 byte thành `key`, `IV` và độ dài ciphertext.
- `decrypt_des_cbc(key, iv, cipher_bytes)`: giải mã DES-CBC và bỏ PKCS#7 padding.
- `RECEIVER_LOG_FILE`: nếu biến môi trường này được đặt, Receiver ghi dòng bản tin gốc vào file log.

## Deliverables bắt buộc
- `README.md`
- `report-1page.md`
- `threat-model-1page.md`
- `peer-review-response.md`
- `tests/` có ít nhất 5 test
- `logs/` có log chạy thật của các ca kiểm thử
- thông tin nhóm, phân công và vai trò demo trong `README.md`

## Threat-model awareness
Vì lab này dùng mô hình gửi DES key và IV dưới dạng plaintext trên cùng luồng TCP, đây là điểm yếu bảo mật nghiêm trọng nếu đưa vào thực tế. Trong `threat-model-1page.md`, nhóm đã nêu rõ:

- assets cần bảo vệ,
- attacker model,
- threats,
- mitigations,
- residual risks.

## Ethics & Safe use
- Chỉ chạy demo trên máy cá nhân, VM, localhost hoặc mạng nội bộ được phép.
- Không quét cổng, không thử nghiệm lên hệ thống không thuộc phạm vi lớp học.
- Không dùng dữ liệu cá nhân thật hoặc dữ liệu nhạy cảm để demo.
- Không trình bày hệ thống này như một giải pháp an toàn sẵn sàng triển khai ngoài đời.
- Nếu tham khảo code/tài liệu, cần ghi nguồn rõ ràng.
- Tôn trọng nguyên tắc trung thực học thuật.

## Submission contract cho CI
CI kiểm tra các điều kiện chính sau:

- có đủ file nộp bài,
- có ít nhất 5 test,
- chạy được kiểm thử local sender/receiver,
- có negative test cho tamper và wrong key,
- `README.md` có Team members, Task division, Demo roles,
- `report-1page.md`, `threat-model-1page.md`, `peer-review-response.md` không còn placeholder của template,
- thư mục `logs/` có ít nhất 1 file log thật.
