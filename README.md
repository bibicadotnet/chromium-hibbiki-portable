<p align="center">
<img src="https://img.bibica.net/qfd6WGhC.png">
</p>

# Chromium Hibbiki Portable với Chrome++ Next Mini

[Chromium Hibbiki](https://github.com/Hibbiki/chromium-win64) được build theo bản stable Chromium 64 bit trên Windows, tác giả Hibbiki hỗ trợ đăng nhập bằng tài khoản Google , giúp đồng bộ hóa dữ liệu, bổ xung Widevine, H.264, HEVC và các codec khác, dễ hiểu thì Chromium Hibbiki nó như 1 bản Chrome tối giản

Lý do tôi lựa chọn phiên bản của Hibbiki vì tác giả rất chịu khó cập nhập, thường 1-2 tuần là có bản mới, lâu thì tầm 1 tháng, nên biết việc tích hợp Google API vào không hề dễ, mỗi khi build cần download 20-40GB dữ liệu, chạy 1-2 ngày mới xong, tác giả vẫn duy trì dự án từ 2019 tới giờ, một công việc rất đáng ngưỡng mộ

Trên phiên bản portable, chỉ thêm vào Chrome++ Next Mini, giúp phiên bản này trở thành bản di động, `debloater.reg` cơ bản là không cần, vì Chromium nguyên bản đã rất sạch sẽ, cá nhân để vào, vì quen dùng là chính :]]

### Tính năng
- Chromium Hibbiki Portable với tất cả dữ liệu được lưu trữ cục bộ
- Phiên bản Chromium Hibbiki độ ổn định cao, sạch, nhẹ tự nhiên
- Hỗ trợ đăng nhập bằng tài khoản Google và đồng bộ hóa dữ liệu
- Hỗ trợ Widevine, H.264, HEVC và các codec độc quyền khác
- Tăng thêm một chút quyền riêng tư, dễ dàng tùy chỉnh theo nhu cầu cá nhân

### Các file và công dụng​
- `chrome++.ini`: File cấu hình cho [Chrome++ Next Mini](https://github.com/bibicadotnet/chrome-next-mini)
- `debloater.reg`: Loại bỏ các tính năng không cần thiết của Chromium
- `default-apps-multi-profile.bat`: Đặt Chromium làm trình duyệt mặc định
- `update.bat`: Cập nhật lên phiên bản mới nhất
- `bypass_windows_defender.bat`: Thêm/xóa thư mục khỏi danh sách loại trừ Windows Defender

### Download

<p align="center">
<img src="https://img.bibica.net/4QCmlxlc.png">
</p>

Download nhanh gọn từ trang [home](https://chromium.bibica.net/), mặc định hiển thị 5 nhánh gần nhất

### Note

- Kể từ 06/08/2026, đổi sang sử dụng [Chrome++ Next Mini](https://github.com/bibicadotnet/chrome-next-mini) để toàn quyền quản lý toàn bộ dự án
