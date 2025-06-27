# College Alert App
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/phlzas/CodeAlpha_CollegeAlertApp)

College Alert App is a cross-platform application built with Flutter designed to help students and faculty stay informed about important campus events and announcements. It provides a real-time feed of alerts, leveraging Firebase Cloud Firestore as its backend for seamless data synchronization.

## Features

- **Real-time Alert Feed:** View a live stream of alerts from Firebase Firestore.
- **Add New Alerts:** Easily create and publish new alerts with a title, description, type, and date/time.
- **Categorized & Color-Coded Alerts:** Alerts are organized by type ('Seminar', 'Exam', 'Fest', 'Notice'), each with a distinct color for quick visual identification.
- **Filter and Sort:** Dynamically filter the alert feed by type and sort alerts by date in either ascending or descending order.
- **Swipe to Delete:** Effortlessly remove alerts with a simple swipe gesture, which updates the database in real-time.
- **Cross-Platform:** Built with Flutter, the app is configured to run on Android, iOS, Web, and Desktop (Windows, macOS, Linux).

## Technology Stack

- **Framework:** Flutter
- **Language:** Dart
- **Database:** Google Firebase Cloud Firestore

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- A configured code editor (like VS Code or Android Studio).
- A Google Firebase account.

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/phlzas/codealpha_collegealertapp.git
    cd codealpha_collegealertapp
    ```

2.  **Set up Firebase:**
    *   Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    *   In your new Firebase project, navigate to the **Firestore Database** section and create a database.
    *   Add an **Android** app to your Firebase project. Use the package name: `com.example.college_alert_app`.
    *   Download the generated `google-services.json` file.
    *   Replace the existing `android/app/google-services.json` file with the one you downloaded.
    *   Repeat the process for any other platforms (iOS, Web) you wish to run the app on.

3.  **Install dependencies:**
    Open a terminal in the project's root directory and run the following command:
    ```sh
    flutter pub get
    ```

4.  **Run the application:**
    Ensure you have a device connected or an emulator running, then execute:
    ```sh
    flutter run
    ```

## Project Structure

-   `lib/main.dart`: The main entry point of the application. It initializes Firebase and contains the `HomeScreen` widget which displays the list of alerts.
-   `lib/AddAlertScreen.dart`: Contains the UI and logic for the screen where users can add new alerts.
-   `firebase_core`, `cloud_firestore`: Key Flutter packages used for integrating Firebase services.
-   Platform-specific directories (`android/`, `ios/`, `web/`, etc.) contain the configuration and native code for each target platform.
