# Danuma Livestream

Ứng dụng hỗ trợ streamer bán hàng với các tính năng xem lượt share, like và in comment. Ứng dụng còn cho phép xem lại danh sách các comment chốt đơn theo từng khách hàng, đánh dấu các khách hàng nào đã xác nhận đơn, đã đi đơn, đã nhận hàng, bom hàng, ...

## Build app icon

```bash
flutter pub run flutter_launcher_icons -f flutter_launcher_icons.yaml
```

## Run dev

```bash
flutter run 
```

Run window application:

```bash
flutter run -d windows
```

## Build release

Build window app:

```bash
flutter build windows
```

App build ra tại thư mục: `\build\windows\x64\runner\Release\vietcare_livestream.exe`.

Build Android app:

```bash
flutter build apk --release
```

App build ra tại thư mục: `build/app/outputs/flutter-apk/app-release.apk`
