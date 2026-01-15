# Firebase Setup Guide for DU Alumni Flutter App

Your Firebase project: **duaab89-67c12**
Project number: **114043642506**

## Current Status
✅ Firebase options file created with placeholder API keys
✅ Demo mode enabled (use `demo@test.com` to test UI)
⚠️ Need real API keys for production authentication

## Steps to Complete Firebase Setup

### For Android

1. **Go to Firebase Console** → Your Project → Project Settings
2. **Click "Add app"** → Select **Android**
3. **Enter package name:** `com.example.du_alumni_flutter`
4. **Download** `google-services.json`
5. **Place the file at:**
   ```
   flutter_app/android/app/google-services.json
   ```
6. **Open the file** and find the `api_key` value
7. **Update `lib/firebase_options.dart`:**
   - Replace `AIzaSyDEPLACEME_ANDROID` with your actual API key
   - Replace `PLACEHOLDER` in appId with the value from the file

### For iOS

1. **Go to Firebase Console** → Your Project → Project Settings
2. **Click "Add app"** → Select **iOS**
3. **Enter iOS bundle ID:** `com.example.duAlumniFlutter`
4. **Download** `GoogleService-Info.plist`
5. **Place the file at:**
   ```
   flutter_app/ios/Runner/GoogleService-Info.plist
   ```
6. **Open the file** and find the `API_KEY` value
7. **Update `lib/firebase_options.dart`:**
   - Replace `AIzaSyDEPLACEME_IOS` with your actual API key
   - Replace `PLACEHOLDER` in appId with the CLIENT_ID from the file

### For Web

1. **Go to Firebase Console** → Your Project → Project Settings
2. **Click "Add app"** → Select **Web**
3. **Register the web app**
4. **Copy the config object** that Firebase shows
5. **Update `lib/firebase_options.dart`:**
   - Replace `AIzaSyDEPLACEME_WEB` with your actual API key
   - Update the appId with the value from Firebase

## Enable Authentication

1. **Go to Firebase Console** → Authentication
2. **Click "Get Started"**
3. **Enable "Email/Password"** sign-in method
4. **Add test users** or allow registration

## Testing

### Demo Mode (No Firebase Required)
- Email: `demo@test.com`
- Password: anything
- This bypasses Firebase and shows the UI

### Real Firebase Login
After completing setup above:
- Create users in Firebase Console → Authentication → Users
- Or enable email/password signup in your app

## Quick Commands

**Hot reload after changes:**
```bash
# Press 'r' in the terminal where flutter run is active
```

**Hot restart (full restart):**
```bash
# Press 'R' in the terminal where flutter run is active
```

**Rebuild after adding Firebase files:**
```bash
cd flutter_app
flutter clean
flutter pub get
flutter run
```

## Files to Update

1. `lib/firebase_options.dart` - Replace all PLACEHOLDER values with actual keys
2. `android/app/google-services.json` - Place downloaded file here
3. `ios/Runner/GoogleService-Info.plist` - Place downloaded file here

## Cross-Platform Testing

**Android Emulator:**
```bash
flutter run -d emulator-5554
```

**iOS Simulator:**
```bash
flutter run -d "iPhone 15 Pro"
```

**List available devices:**
```bash
flutter devices
```

## Current Backend Integration

Your Flutter app is configured to connect to:
- Base URL: `http://10.0.2.2:3000` (Android emulator → localhost)
- Change in: `lib/core/api/dio_client.dart`

**For iOS simulator, update to:**
```dart
baseUrl: 'http://localhost:3000'
```

**For production:**
```dart
baseUrl: 'https://your-production-url.com'
```

## Next Steps

1. ✅ Test demo mode with `demo@test.com`
2. Add Android app in Firebase Console
3. Add iOS app in Firebase Console  
4. Download config files and update API keys
5. Enable Authentication in Firebase
6. Test real login
7. Update backend URL for production
