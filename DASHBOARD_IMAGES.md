# Dashboard Images Update

## ✅ Images Updated from Next.js Backend

All dashboard card background images have been updated to use the actual hero images from the Next.js UI.

### Image Mappings:

| Dashboard Card | Image URL | Source Page |
|---------------|-----------|-------------|
| **Home** | `http://10.0.2.2:3000/home_page/Banner.jpg` | Home page hero banner |
| **Members** | `http://10.0.2.2:3000/home_page/Banner.jpg` | Alumni Directory page |
| **News** | `http://10.0.2.2:3000/News & Events/Banner.jpg` | News page hero |
| **Events** | `http://10.0.2.2:3000/News & Events/Banner.jpg` | News & Events page |
| **Gallery** | `http://10.0.2.2:3000/gallery/gallery_hero_bg.jpg` | Gallery page hero |
| **About** | `http://10.0.2.2:3000/images/About Us/Main-Banner.jpg` | About Us page hero |

### How It Works:

1. **Next.js Server**: Running on `localhost:3000`, serves static files from the `/public` folder
2. **Android Emulator**: Uses `10.0.2.2` to access host machine's `localhost`
3. **Flutter App**: Loads images via `Image.network()` from Next.js server
4. **Fallback**: If images fail to load, colored gradients are shown instead

### Prerequisites:

**Both servers must be running:**

1. **Next.js Server** (Terminal 1):
   ```bash
   cd "/Users/tasneemzaman/Desktop/DU ALUMNI  APP"
   npm run dev
   ```
   Server runs on: `http://localhost:3000`

2. **Flutter App** (Terminal 2):
   ```bash
   cd "/Users/tasneemzaman/Desktop/DU ALUMNI  APP/flutter_app"
   flutter run -d emulator-5554
   ```

### Testing:

1. Ensure Next.js server is running (see above)
2. Run Flutter app on emulator
3. Login with `demo@test.com`
4. Dashboard should now show actual images from Next.js UI

### Network Details:

- **Host Machine**: `localhost:3000` (Next.js server)
- **Android Emulator**: `10.0.2.2:3000` (maps to host's localhost)
- **iOS Simulator**: Would use `localhost:3000` directly

### File Structure:

```
Next.js Backend (/public folder):
├── home_page/
│   └── Banner.jpg ✅ (Home, Members)
├── News & Events/
│   └── Banner.jpg ✅ (News, Events)
├── gallery/
│   └── gallery_hero_bg.jpg ✅ (Gallery)
└── images/
    └── About Us/
        └── Main-Banner.jpg ✅ (About)
```

### Troubleshooting:

**Images not loading?**

1. Check Next.js server is running:
   ```bash
   lsof -ti:3000 && echo "Running" || echo "Not running"
   ```

2. Test image accessibility:
   ```bash
   curl -I http://localhost:3000/home_page/Banner.jpg
   ```
   Should return `HTTP/1.1 200 OK`

3. Check emulator network:
   - Android emulator uses `10.0.2.2` to access host's `localhost`
   - Make sure no firewall is blocking port 3000

**See gradient colors instead of images?**

This means the image failed to load. Check:
- Next.js server is running
- Image paths are correct (check file names in `/public` folder)
- Network connectivity from emulator to host

### Production Deployment:

For production, replace `http://10.0.2.2:3000` with your actual production URL:

```dart
// Development (current)
'http://10.0.2.2:3000/home_page/Banner.jpg'

// Production (update when deployed)
'https://your-production-domain.com/home_page/Banner.jpg'
```

Or create a config constant:

```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 
    kReleaseMode 
      ? 'https://your-production-domain.com'
      : 'http://10.0.2.2:3000';
}

// Usage
'${ApiConfig.baseUrl}/home_page/Banner.jpg'
```
