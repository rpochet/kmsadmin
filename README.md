# kmsadmin

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Deploy

flutter build web --base-href "/kmsadmin/"
cd build/web
aws s3 sync . s3://aws-irl-bucket-kms-dev-0a2f0ffbebc9/admin/kmsadmin/

# Emulator

flutter pub cache clean
flutter pub get
flutter clean
flutter packages get

## Android 

flutter emulators --launch Pixel_3a_API_33_x86_64

# Library 

## Intl

