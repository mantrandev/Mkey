# Mkey

Bộ gõ tiếng Việt cho macOS — fork từ [OpenKey](https://github.com/tuyenvm/OpenKey), stripped down cho cá nhân.

## Tải về

| Bản | Kiểu gõ | Link |
|---|---|---|
| Đầy đủ (Telex + VNI) | Telex / VNI | [Mkey-v0.0.4.dmg](https://github.com/mantrandev/Mkey/releases/tag/v0.0.4) |
| VNI only | VNI (cố định) | [Mkey-vni-v0.0.4.dmg](https://github.com/mantrandev/Mkey/releases/tag/vni-v0.0.4) |
| Telex only | Telex (cố định) | [Mkey-telex-v0.0.4.dmg](https://github.com/mantrandev/Mkey/releases/tag/telex-v0.0.4) |

## Screenshot

![Mkey menu](docs/screenshot.png)

## Tính năng

- **Kiểu gõ:** Telex, VNI
- **Bảng mã:** Unicode
- **Phím tắt chuyển ngôn ngữ:** `Ctrl + Space`
- **Menu bar SwiftUI** — hiển thị `V` (tiếng Việt) hoặc `E` (tiếng Anh)
- **Gõ dấu** ở bất kì chỗ nào trong từ ở VNI
  - MinhBeo1 | MinhBe1o -> MinhBéo
  - Diu91 | D9i1u -> Đíu

## Yêu cầu

macOS 14.0+.

**Gatekeeper:** Vì app chưa được notarize, cần bỏ chặn thủ công sau khi cài:  
*System Settings → Privacy & Security* → tìm `Mkey` → bấm **Open Anyway**.

**Accessibility:** Cấp quyền để app hoạt động:  
*System Settings → Privacy & Security → Accessibility* → bật `Mkey`.

**Text Input:** Để Mkey hoạt động mượt, chỉ giữ **một** input source là `U.S.` (English) trong *System Settings → Keyboard → Text Input → Input Sources*. Xoá hết các input source tiếng Việt (Telex/VNI) của macOS — Mkey tự xử lý phần gõ.

![Text Input config](docs/text-input.png)

## Cài đặt

**Homebrew (khuyến nghị):**

```bash
brew tap mantrandev/tap
brew install --cask mantrandev/tap/mkey
```

**Thủ công:**

1. Tải `Mkey.dmg` từ [Releases](https://github.com/mantrandev/Mkey/releases)
2. Mở DMG, kéo `Mkey.app` vào thư mục `Applications`

**Sau khi cài (cả hai cách):**

1. Mở `Mkey` — hệ thống sẽ yêu cầu cấp quyền Accessibility
2. Vào *System Settings → Privacy & Security → Accessibility* → bật `Mkey`
3. Mở lại `Mkey`

## Build

Mở `Sources/macOS/Mkey.xcodeproj`, chọn scheme `Mkey`, build.

- **Debug:** bundle ID `com.mantrandev.mkey.dev`
- **Release:** bundle ID `com.mantrandev.mkey`
