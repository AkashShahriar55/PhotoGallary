# Photo Gallery

A simple Flutter-based photo gallery application that integrates native platform channels to fetch and display local gallery images without using third-party packages.

## Requirements

- **No Third-Party Packages:** Fetch images from the device gallery using native Android and iOS code through platform channels.
- **Native Implementation:** Native platform-specific code (Kotlin/Swift) is used to retrieve images.
- **Image Grid:** Display images in a 4x4 grid layout.
- **Selection Feature:** Allow users to select images. Selected images display a tick icon.
- **Blur Effect:** Selected images appear blurred.
- **Download Functionality:** Include a download button that saves selected images individually back to the device gallery/photos.
- **Loading Indicators:** Display loading indicators appropriately during image retrieval and saving.

## Getting Started

### Flutter Setup

Make sure Flutter is installed and properly configured:

- [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)

### Generate App Icons

This project uses `flutter_launcher_icons`. To generate launcher icons, run:

```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
```

### Running the App

Run the following commands to start the app:

```bash
flutter clean
flutter pub get
flutter run
```

### iOS Setup

Since this project uses native iOS code, ensure CocoaPods is installed and set up correctly:

```bash
cd ios
pod install
```

Then, run the app using Flutter:

```bash
flutter run
```

## Project Structure

- **Native Android (Kotlin)**: Handles fetching and saving images through platform channels.
- **Native iOS (Swift)**: Handles fetching and saving images through platform channels.
- **Flutter UI**: Displays images in a grid, allows selection with blur and tick effects, and manages image downloads.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Platform Channels](https://docs.flutter.dev/platform-integration/platform-channels)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

---

## Code Coverage

You can view the latest coverage report [here](docs/html/index.html).
