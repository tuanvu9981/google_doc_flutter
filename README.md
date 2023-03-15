# Google Document with Flutter

## Setting up with Google Cloud OAuth Credentials
1. Vào phần Google Cloud console.
Lựa chọn mũi tên drop-down của project gần đây nhất để chọn tạo 1 project mới trên thanh công cụ 
<p align="center">
  <img 
    src="https://github.com/tuanvu9981/google_doc_flutter/blob/master/illustration_readme/tools.png" 
    title="Toolbar"
    width="100%"
  >
</p>

2. Chọn **"New Project"**, điền tên project & chọn **Location** (địa điểm) là **"No organization"** (Không có tổ chức nào)
<p align="center">
  <img 
    src="https://github.com/tuanvu9981/google_doc_flutter/blob/master/illustration_readme/create_new.png"
    width="100%"
  >
</p>

3. Chọn **Dashboard** (dưới toolbar). Tab bên trái có nhiều options. 
Lựa chọn **APIs & Services** >> **Credentials** (danh tính).
Trên toolbar ở đây, lựa chọn **+ CREATE CREDENTIALS** >> **OAuth Client ID**
(Sử dụng OAuth để xác thực đăng nhập bằng Google Account)

4. Ở đây, nếu là lần đầu, thì cần phải chỉnh sửa **Consent**. 
Lựa chọn điền các thông tin như **app_name**, **email to register** & **email to contact with**
   - Tiếp theo, chọn SCOPE (email + personal information)
   - Tiếp theo, chọn Test Users (điền email của testers vào - tối đa 100 người)
   - Tiếp theo, confirm và nhấn back về Dashboard 

5. Nếu đã được xác nhận, thì từ những lần sau, khi chọn **Create OAuth client ID**, thì sẽ có các options sau: 
   - Web 
   - iOS 
   - Android 
   ... 

6. Nếu chọn Android, cần điền các thông tin sau 
<p align="center">
  <img 
    src="https://github.com/tuanvu9981/google_doc_flutter/blob/master/illustration_readme/android.png"
    width="100%"
  >
</p>
- Tên package thì lấy ở manifest.xml của thư mục android flutter 
- Mã sha-1 thì sinh ra bằng cách 
```
~/google_doc_flutter$ cd android
~/google_doc_flutter/android$ ./gradlew signingReport
```

7. Lưu ý điều chỉnh sdkVersion lên 21 (thay vì 19 như default set up)

## Setting up with Google Cloud OAuth Credentials