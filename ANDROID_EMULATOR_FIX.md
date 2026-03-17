# Android Emulator Fix - Connection Refused Error

## What Was Wrong

You were getting "Connection refused" because the Android emulator was trying to connect to `localhost:3000`, which doesn't work. The emulator runs in a virtual machine and can't reach your host machine's localhost.

## What I Fixed

Updated the API and WebSocket clients to use `10.0.2.2` instead of `localhost` for Android emulator:

- **API Client:** Now uses `http://10.0.2.2:3000` (Android emulator's way to reach host localhost)
- **WebSocket Client:** Now uses `ws://10.0.2.2:3001`

This is the standard way Android emulators reach the host machine.

## What You Need to Do

### Step 1: Start the API Server

Open a terminal on your **host machine** (your computer):

```bash
cd mock-api
npm install
npm start
```

Wait for:
```
JSON Server running on http://localhost:3000
WebSocket server listening on ws://localhost:3001
```

**Keep this terminal open.**

### Step 2: Run the App

In a **new terminal**, run:

```bash
flutter run
```

The app will automatically connect to `10.0.2.2:3000` (which reaches your host machine).

### Step 3: Check the Console

You should see:
```
[API] GET /driver/shift
[API Success] GET /driver/shift
```

If you see `[API Failed]`, the API server is not running. Go back to Step 1.

---

## How It Works

**Android Emulator → 10.0.2.2:3000 → Your Host Machine's localhost:3000**

The emulator uses `10.0.2.2` as a special alias to reach your host machine.

---

## If You're Using a Physical Device

If you're using a physical Android device instead of the emulator:

1. **Find your machine's IP:**
   ```bash
   ifconfig | grep "inet "  # macOS/Linux
   ipconfig                 # Windows
   ```
   Look for something like `192.168.1.100`

2. **Update the API client:**
   Edit `lib/core/api/api_client.dart`:
   ```dart
   final defaultUrl = baseUrl ?? 'http://192.168.1.100:3000';
   ```

3. **Update the WebSocket client:**
   Edit `lib/core/api/websocket_client.dart`:
   ```dart
   _url = url ?? 'ws://192.168.1.100:3001'
   ```

4. **Make sure your device is on the same WiFi** as your computer

5. **Run the app:**
   ```bash
   flutter run
   ```

---

## If You're Using iOS Simulator

iOS simulator can use `localhost` directly, so no changes needed. Just run:

```bash
flutter run -d iPhone
```

---

## Summary

| Device | API URL | WebSocket URL | Status |
|--------|---------|---------------|--------|
| Android Emulator | `10.0.2.2:3000` | `10.0.2.2:3001` | ✅ Fixed |
| iOS Simulator | `localhost:3000` | `localhost:3001` | ✅ Works |
| Physical Device | `YOUR_IP:3000` | `YOUR_IP:3001` | ⚠️ Manual update needed |
| Web | `localhost:3000` | `localhost:3001` | ✅ Works |

---

## Next Steps

1. **Start API server:** `cd mock-api && npm start`
2. **Run app:** `flutter run`
3. **Check console:** Look for `[API Success]` messages
4. **See 3 orders** in the app

If you still see errors, check `TROUBLESHOOTING.md` or `ANDROID_EMULATOR_SETUP.md`.
