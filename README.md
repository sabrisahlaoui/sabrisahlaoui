# Multifactor Authentication Mobile Application

## Introduction

This mobile application implements multifactor authentication (MFA) using Flutter and Firebase. It provides an additional layer of security by requiring users to authenticate using an OTP sent via email followed by an OTP sent to their phone number.

## Features

- **Email OTP Authentication:** Sends a one-time password (OTP) to the user's registered email address.
- **Phone OTP Authentication:** Sends a one-time password (OTP) to the user's phone number for a second layer of security.
- **Secure Login:** Protects user accounts from unauthorized access through multifactor authentication.

## Requirements

- Flutter 2.0 or higher
- Firebase project set up with Firebase Authentication and Firebase Cloud Messaging

## Installation

1. **Clone the Repository**
    
    ```bash
    git clone https://github.com/sabrisahlaoui/MFA-mobile-app.git
    cd MFA-mobile-app
    
    ```
    
2. **Set Up Flutter Environment**
Ensure you have Flutter installed. Follow the official Flutter installation guide [here](https://flutter.dev/docs/get-started/install).
3. **Install Dependencies**
Run the following command to install the required dependencies.
    
    ```bash
    flutter pub get
    
    ```
    
4. **Configure Firebase**
    - Go to the Firebase Console and create a new project.
    - Add an Android app and an iOS app to your Firebase project.
    - Download the `google-services.json` file for Android and place it in the `android/app` directory.
    - Download the `GoogleService-Info.plist` file for iOS and place it in the `ios/Runner` directory.
    - Enable Email/Password and Phone authentication methods in the Firebase Authentication section.
5. **Update Configuration Files**
    - Update the `android/app/build.gradle` file to include the Google services classpath and plugin.
    - Update the `ios/Runner/Info.plist` file to configure Firebase.

## Usage

1. **Registration and Login**
    - Users must register with their email address and phone number.
    - Upon login, they will receive an OTP via email.
    - After entering the email OTP, they will receive another OTP on their phone number.
2. **OTP Authentication**
    - The first OTP is sent to the user's registered email address.
    - The second OTP is sent to the user's phone number.

## Folder Structure

```
/android         - Contains Android-specific files
/ios             - Contains iOS-specific files
/lib             - Contains the Dart code (main.dart, screens, models, widgets, services)
/assets          - Contains static assets (images)
/pubspec.yaml    - Flutter project configuration file
README.md        - Project documentation

```

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss your ideas.

## Contact

For questions or support, please open an issue or contact [sabri.sahlaoui@enis.tn](mailto:sabri.sahlaoui@enis.tn).
