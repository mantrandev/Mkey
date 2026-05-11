# Mkey

Bộ gõ tiếng Việt cho macOS — fork từ [OpenKey](https://github.com/tuyenvm/OpenKey), stripped down cho cá nhân.

## Tính năng

- **Kiểu gõ:** Telex, VNI
- **Bảng mã:** Unicode (precomposed)
- **Gõ tắt (Macro):** không giới hạn ký tự
- **Quick Telex:** `cc=ch`, `gg=gi`, `kk=kh`, `nn=ng`, `qq=qu`, `pp=ph`, `tt=th`
- **Đặt dấu oà uý** (mặc định bật)
- **Chạy cùng macOS**
- **Phím tắt chuyển ngôn ngữ** tùy chỉnh
- **Sửa lỗi autocorrect** trên Chrome, Safari, Firefox, Excel

## Yêu cầu

macOS 10.14+. Cần cấp quyền Accessibility:  
*System Settings → Privacy & Security → Accessibility* → bật `Mkey`.

## Build

Mở `Sources/OpenKey/macOS/Mkey.xcodeproj`, chọn scheme `Mkey`, build.

## Nguồn gốc

Fork từ [tuyenvm/OpenKey](https://github.com/tuyenvm/OpenKey) — GPL license.
