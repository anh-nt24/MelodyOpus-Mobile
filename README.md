# MelodyOpus - Mobile

This repository hosts the mobile frontend code for a modern music player application built with Flutter. The application allows users to stream music, create playlists, follow artists, and manage their profiles.

Backend: [Check here](https://github.com/anh-nt24/MelodyOpus-Backend)

## Features
- User authentication (OAuth2, JWT)
- Online and offline music streaming
- Download songs
- Playlist and song management (being developed)
- Follow and unfollow artists (being developed)
- Like and unlike songs (being developed)
- Profile management (being developed)
- Track listening history (being developed)

## Technologies Used
- Flutter
- Dart
- Provider for state management
- JustAudio for audio playback
- HTTP for network requests
- Firebase for authentication and other backend services
- Sqflite for local database management

## Getting Started

To get started with the MelodyOpus mobile application, follow these steps:

1. **Clone the repository:**
   ```sh
   git clone https://github.com/anh-nt24/MelodyOpus-Mobile.git
   cd MelodyOpus-Mobile
    ```

2. **Install dependencies:**
    ```sh
    flutter pub get
    ```

3. **Set up Firebase:**

    *Set up Firebase for Google sign in, and download google-service.json file*

4. **Run the application:**

    Run the backend first. Check the [repo](https://github.com/anh-nt24/MelodyOpus-Backend) for instructions
    ```
    flutter run
    ```
