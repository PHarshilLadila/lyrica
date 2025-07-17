# Lyrica Music Player

Lyrica is a Flutter application designed for music playback and management. It allows users to browse their music library, play tracks, and manage their reward points for accessing premium features.

## Features

- **Music Playback**: Play, pause, skip, and rewind music tracks.
- **Reward Points System**: Users earn points by interacting with the app, which can be used to unlock premium features.
- **Library Management**: Browse and manage your music library with ease.
- **Global Mini Player**: A compact music player interface that can be accessed from anywhere in the app.

## Getting Started

To get started with the Lyrica app, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/lyrica.git
   cd lyrica
   ```

2. **Install Dependencies**:
   Make sure you have Flutter installed on your machine. Then run:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   You can run the application using:
   ```bash
   flutter run
   ```

## Project Structure

The project is organized as follows:

- `lib/main.dart`: Entry point of the application.
- `lib/model/music_model.dart`: Defines the data model for music tracks.
- `lib/core/constant/app_colors.dart`: Contains color constants for theming.
- `lib/core/providers/provider.dart`: Exports various providers for state management.
- `lib/common/utils/utils.dart`: Utility functions for formatting and validation.
- `lib/common/widget/`: Contains reusable widgets like buttons and text styles.
- `lib/modules/library/view/library_screen.dart`: Library screen for managing music.
- `lib/modules/music player/view/music_player.dart`: Main music player functionality.
- `lib/modules/music player/view/mini_player.dart`: Global mini player interface.

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.