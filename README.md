<p align="center">
<img src="https://img.bibica.net/qfd6WGhC.png">
</p>

# Chromium Hibbiki Portable Debloat với Chrome++

Chromium Hibbiki được build theo bản stable Chromium 64 bit trên Windows, tác giả Hibbiki hỗ trợ đăng nhập bằng tài khoản Google , giúp đồng bộ hóa dữ liệu, bổ xung Widevine, H.264, HEVC và các codec khác, dễ hiểu thì Chromium Hibbiki nó như 1 bản Chrome tối giản

Lý do tôi lựa chọn phiên bản của Hibbiki vì tác giả rất chịu khó cập nhập, thường 1-2 tuần là có bản mới, lâu thì tầm 1 tháng, nên biết việc tích hợp Google API vào không hề dễ, mỗi khi build cần download 20-40GB dữ liệu, chạy 1-2 ngày mới xong, tác giả vẫn duy trì dự án từ 2019 tới giờ, một công việc rất đáng ngưỡng mộ

Trên phiên bản portable, tôi chỉ thêm vào Chrome++, giúp phiên bản này trở thành bản di động, còn lại cũng không chỉnh sửa thêm gì, debloater.reg cơ bản là không cần, vì Chromium nguyên bản đã rất sạch sẽ, cá nhân để vào, vì quen dùng là chính :]]

### Tính năng
- Chromium Hibbiki Portable với tất cả dữ liệu được lưu trữ cục bộ, vẫn duy trì hỗ trợ Manifest V2
- Phiên bản Chromium Hibbiki độ ổn định cao, sử dụng ít tài nguyên CPU và RAM
- Hỗ trợ đăng nhập bằng tài khoản Google và đồng bộ hóa dữ liệu
- Hỗ trợ Widevine, H.264, HEVC và các codec độc quyền khác (không bị lỗi liên quan tới DRM)
- Tối ưu hiệu năng, tăng thêm một chút quyền riêng tư, dễ dàng tùy chỉnh theo nhu cầu cá nhân

### Các file và công dụng​
- `chrome++.ini`: File cấu hình cho [Chrome++](https://github.com/Bush2021/chrome_plus)
- `debloater.reg`: Loại bỏ các tính năng không cần thiết của Chromium
- `default-apps-multi-profile.bat`: Đặt Chromium làm trình duyệt mặc định
- `update.bat`: Cập nhật lên phiên bản mới nhất

### Download

<p align="center">
<img src="https://img.bibica.net/4QCmlxlc.png">
</p>

Download nhanh gọn từ trang [home](https://chromium.bibica.net/), mặc định hiển thị 5 nhánh gần nhất
