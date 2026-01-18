# Nth Tiktok Live Comment

Ứng dụng hỗ trợ streamer bán hàng với các tính năng xem lượt share, like và in comment.

Ứng dụng có có 2 thành phần chính: 
* Tiktok Live Engine: là thành phần backend, được phát triển bằng NodeJS để kết nối với các phiên live từ Tiktok, lấy thông tin trong phiên live (comment, share, like, ...) và cung cấp dữ liệu cho frontend thông qua Websocket.
* Vietcare Livestream: là thành phần frontend để hiển thị cho phép in các comment trong phiên like, hiển thị danh sách người xem phiên livestream cùng với số lần share và like.