# chari - Ứng dụng Mobile hỗ trợ hoạt động từ thiện

# Backend được xây dựng bằng JAVA Spring Boot

# Database - PostgreSQL

# Frontend - Flutter: Mobile app cho nhà từ thiện

# Các bước cài đặt ứng dụng.

## I. Cài đặt database:
###	1. Cài đặt PostgreSQL trên localhost cổng 5432
###	2. Tạo một database có tên là chari và user của database này là postgres có mật khẩu là 123

## II. Cài đặt Backend server:
### 1. Cài đặt Java 14 mở ứng dụng và get tất cả dependences trong pom.xml
###	2. mở điểm truy cập cá nhân trên máy tính, dùng thiết bị di động mà bạn muốn cài đặt ứng dụng bắt lấy wifi đã phát
### 3. mở cmd và run 'ipconfig' copy ipv4 tại Wireless LAN adapter Local Area Connection (đây là trên máy của tôi hãy kiểm tra kỹ trên máy bạn)
###	4. Dán ipv4 ở bước 2 tại thuộc tính server.address trong file application.properties
### 5. Cấu hình cho Paypal Sanbox của riêng bạn hoặc có thể sử dụng config của tôi trong application.properties.

## III. Cài đặt Frontend Flutter:
###	1. Xem cài đặt Flutter tại https://flutter.dev/docs/get-started/install
###	2. Run code và get tất cả package trong pubspec.yaml
### 3. Thay đổi ipv4 trong const baseUrl trong file API.dart bằng ipv4 mà bạn đã tìm được tại bước II.3



