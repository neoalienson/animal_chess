# Logo Integration Instructions

This document provides instructions on how to apply your logo (`assets/logo.png`) to different platforms in your Flutter project.

## Prerequisites

Before you begin, you'll need to generate different sizes of your logo.png file for various platforms. You can use online tools like [https://www.favicon-generator.org/](https://www.favicon-generator.org/) or image editing software to create these sizes.

## Android

Replace the `ic_launcher.png` files in each mipmap directory with appropriately sized versions of your logo:

```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png (72x72)
├── mipmap-mdpi/ic_launcher.png (48x48)
├── mipmap-xhdpi/ic_launcher.png (96x96)
├── mipmap-xxhdpi/ic_launcher.png (144x144)
├── mipmap-xxxhdpi/ic_launcher.png (192x192)
```

## iOS

Replace the `Icon-App-*.png` files in the AppIcon.appiconset directory with appropriately sized versions of your logo:

```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
├── Icon-App-20x20@1x.png (20x20)
├── Icon-App-20x20@2x.png (40x40)
├── Icon-App-20x20@3x.png (60x60)
├── Icon-App-29x29@1x.png (29x29)
├── Icon-App-29x29@2x.png (58x58)
├── Icon-App-29x29@3x.png (87x87)
├── Icon-App-40x40@1x.png (40x40)
├── Icon-App-40x40@2x.png (80x80)
├── Icon-App-40x40@3x.png (120x120)
├── Icon-App-60x60@2x.png (120x120)
├── Icon-App-60x60@3x.png (180x180)
├── Icon-App-76x76@1x.png (76x76)
├── Icon-App-76x76@2x.png (152x152)
├── Icon-App-83.5x83.5@2x.png (167x167)
├── Icon-App-1024x1024@1x.png (1024x1024)
```

## Web

Replace the following files with appropriately sized versions of your logo:

```
web/
├── favicon.png (16x16 or 32x32)
├── icons/Icon-192.png (192x192)
├── icons/Icon-512.png (512x512)
├── icons/Icon-maskable-192.png (192x192)
├── icons/Icon-maskable-512.png (512x512)
```

## Steps to Complete

1. Generate all required image sizes from your `assets/logo.png` file
2. Replace the existing files in the directories mentioned above
3. Run `flutter pub get` to ensure the asset is properly included
4. Test your app on different platforms to verify the logo appears correctly

## Additional Notes

- For iOS, you may also need to update the `Contents.json` file in the AppIcon.appiconset directory if you change file names
- For web, make sure to update the `manifest.json` file if you change icon file names
- Always test your app on all target platforms after making these changes
