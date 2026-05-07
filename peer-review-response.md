# Peer Review Response

## Thông tin nhóm
- Thành viên 1: [Điền họ tên] - MSSV: [Điền MSSV] - phụ trách Sender
- Thành viên 2: [Điền họ tên] - MSSV: [Điền MSSV] - phụ trách Receiver

## Góp ý cho phần Sender
Phần Sender đã tạo được DES key, IV, ciphertext và gửi packet đúng định dạng cho Receiver. Điểm cần làm rõ khi demo là Sender không chỉ gửi ciphertext mà còn gửi cả key, IV và length header để Receiver có thể giải mã. Sau góp ý, phần README và report đã bổ sung mô tả rõ hơn về `encrypt_des_cbc()`, `build_packet()`, packet format và log phía gửi. Sender cũng ghi log key, IV và ciphertext để dễ đối chiếu khi demo.

## Góp ý cho phần Receiver
Phần Receiver đã xử lý đúng luồng nhận dữ liệu: mở server socket, nhận header, tách key/IV/length, nhận ciphertext và giải mã DES-CBC. Điểm cần làm rõ là vì sao phải dùng `recv_exact()` thay vì gọi `recv()` một lần. Sau góp ý, README và report đã bổ sung giải thích rằng TCP là byte stream, nên Receiver phải nhận đúng số byte theo header để tránh đọc thiếu dữ liệu. Receiver cũng ghi log bản tin gốc để có minh chứng nộp bài.

## Nhóm đã sửa gì sau góp ý
Nhóm đã hoàn thiện tài liệu cho cả Sender và Receiver, bao gồm Task division, Demo roles, Input/Output, Sender implementation notes và Receiver implementation notes trong README. Report được cập nhật để mô tả đầy đủ cả hai chiều gửi/nhận. Threat model được chỉnh lại để nêu rõ các rủi ro chính như eavesdropping, tampering, man-in-the-middle, replay, denial of service và log exposure. Nhóm cũng bổ sung hướng giảm thiểu như TLS, AES, HMAC/AEAD, nonce/timestamp, socket timeout và giới hạn kích thước dữ liệu.

## Kết quả kiểm tra lại
Sau khi chỉnh sửa, nhóm chạy demo local để tạo log minh chứng cho cả Sender và Receiver. Sender log được lưu tại `logs/01-happy-path-sender.txt`, Receiver log được lưu tại `logs/01-happy-path-receiver.txt`. Bộ test tự động được giữ lại để kiểm tra padding/header, packet contract, local sender-receiver, tamper negative test và wrong-key negative test.

## Phản hồi cuối cùng
Nhóm thống nhất rằng phiên bản hiện tại đáp ứng yêu cầu chính của lab: có code Sender/Receiver, có packet format rõ ràng, có test, có log demo, có report, có threat model và có phần giải thích an toàn/đạo đức. Hạn chế bảo mật lớn nhất vẫn là key được gửi plaintext cùng packet, nên nhóm đã nêu rõ đây là thiết kế phục vụ học tập, không dùng trong thực tế.
