MLM Client Flutter
==================

This is a Flutter client that integrates with the MLM backend hosted at `https://mlm-database.onrender.com`.

Quick start
- Ensure Flutter SDK is installed (3.19+ recommended).
- Open this `flutter_app` folder in your IDE.
- Run `flutter pub get`.
- If platform folders (android/ios/web/etc.) are missing, run `flutter create .` once inside this folder.
- Update `lib/core/config.dart` if you want to change the backend base URL.
- Run the app on a device/emulator.

Notes
- Authentication uses JWT via `Authorization: Bearer <token>` header.
- OTP flows may send SMS/Email via provider keys configured on the backend.
- Razorpay payments require device setup; ensure keys are configured server-side and test in sandbox.
