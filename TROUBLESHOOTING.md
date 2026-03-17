# Troubleshooting Guide

## "Failed to load orders" or "Failed to load route"

### Root Cause
The mock API server is not running or not accessible.

### Solution

**Step 1: Start the API Server**

Open a **new terminal** (separate from the one running `flutter run`):

```bash
cd mock-api
npm install  # Only needed first time
npm start
```

You should see:
```
JSON Server running on http://localhost:3000
WebSocket server listening on ws://localhost:3001
```

**Step 2: Check the Console**

Look at the Flutter console output. You should see:
```
[API] GET /driver/shift
[API Success] GET /driver/shift
```

If you see:
```
[API] GET /driver/shift
[API Failed] GET /driver/shift: Connection timeout - is the API server running on http://localhost:3000?
```

Then the API server is not running.

**Step 3: Verify Ports**

Check if ports 3000 and 3001 are in use:

```bash
# macOS/Linux
lsof -i :3000
lsof -i :3001

# Windows
netstat -ano | findstr :3000
netstat -ano | findstr :3001
```

If ports are in use by another process, either:
1. Kill the process
2. Or change the port in `mock-api/package.json`

**Step 4: Retry**

Once the API server is running, pull-to-refresh on the order list or restart the app.

---

## "Connection timeout" Error

### Cause
The API server is not responding within 10 seconds.

### Solutions

1. **Check if API server is running:**
   ```bash
   cd mock-api && npm start
   ```

2. **Check if ports are blocked:**
   ```bash
   # Try connecting manually
   curl http://localhost:3000/driver/shift
   ```

3. **Increase timeout** (if API is slow):
   Edit `lib/core/api/api_client.dart`:
   ```dart
   connectTimeout: const Duration(seconds: 30),  // Increase from 10
   receiveTimeout: const Duration(seconds: 30),
   ```

---

## "Module not found" Error

### Cause
npm dependencies not installed.

### Solution

```bash
cd mock-api
npm install
npm start
```

---

## "Port 3000 already in use"

### Cause
Another process is using port 3000.

### Solution

**Option 1: Kill the process**

```bash
# macOS/Linux
lsof -i :3000
kill -9 <PID>

# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

**Option 2: Use a different port**

Edit `mock-api/package.json`:
```json
"scripts": {
  "start": "concurrently \"json-server --watch db.json --port 3001\" \"node ws-server.js\""
}
```

Then update `lib/core/api/api_client.dart`:
```dart
baseUrl: baseUrl ?? 'http://localhost:3001',
```

---

## WebSocket Not Connecting

### Symptoms
- Orders don't update in real-time
- No WebSocket messages in console

### Cause
WebSocket server on port 3001 is not running.

### Solution

1. **Check if API server is running:**
   ```bash
   cd mock-api && npm start
   ```

2. **Check console for WebSocket errors:**
   Look for `[WebSocket]` messages in Flutter console.

3. **Verify port 3001 is open:**
   ```bash
   lsof -i :3001
   ```

---

## "Location permission denied"

### Symptoms
- Route map doesn't show driver position
- GPS marker not updating

### Cause
Location permission not granted.

### Solution

**Android:**
1. Open app settings
2. Go to Permissions
3. Enable Location

**iOS:**
1. Open app settings
2. Go to Privacy
3. Enable Location

**Web:**
- Browser will prompt for location permission
- Click "Allow"

---

## App Crashes on Startup

### Cause
Usually a null safety or initialization error.

### Solution

1. **Check console for error message**
2. **Run `flutter clean`:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Check if API server is running**

---

## "LateInitializationError" on WebSocket

### Cause
WebSocket client disposed before initialization.

### Solution

This should be fixed in the latest version. If you still see it:

1. Restart the app
2. Make sure API server is running
3. Check Flutter console for other errors

---

## Orders Not Updating in Real-Time

### Cause
WebSocket connection not established or listening.

### Solution

1. **Check WebSocket is running:**
   ```bash
   cd mock-api && npm start
   ```

2. **Check console for WebSocket messages:**
   Should see `[WebSocket]` logs every 30 seconds.

3. **Check order list is using WebSocket provider:**
   - Pull-to-refresh should still work
   - Manual refresh should show updated orders

---

## Map Not Loading

### Cause
- OpenStreetMap tiles not loading
- GPS permission denied
- Route geometry invalid

### Solution

1. **Check internet connection** (tiles need to download)

2. **Grant location permission:**
   - Android: Settings > Permissions > Location
   - iOS: Settings > Privacy > Location

3. **Check console for errors:**
   Look for `[API]` or `[WebSocket]` errors.

---

## Status Update Button Not Working

### Cause
- API server not running
- Invalid status transition
- Network error

### Solution

1. **Check API server is running:**
   ```bash
   cd mock-api && npm start
   ```

2. **Check valid transitions:**
   - ASSIGNED → PICKED_UP ✓
   - PICKED_UP → EN_ROUTE ✓
   - EN_ROUTE → DELIVERED or FAILED ✓
   - DELIVERED → (no action)
   - FAILED → (no action)

3. **Check console for error message:**
   Should show SnackBar with error details.

---

## Pull-to-Refresh Not Working

### Cause
- Provider not properly invalidated
- State not updating

### Solution

1. **Check order list is using correct provider:**
   Should use `orderListNotifierProvider`

2. **Try manual refresh:**
   - Go to another screen
   - Come back to order list

3. **Restart app:**
   ```bash
   flutter run
   ```

---

## Performance Issues / App Janky

### Cause
- Too many rebuilds
- GPS updates too frequent
- Map rendering issues

### Solution

1. **Check console for excessive logs:**
   Should see `[API]` logs only when needed.

2. **Reduce GPS update frequency:**
   Edit `lib/features/route_map/route_map_provider.dart`:
   ```dart
   distanceFilter: 50,  // Increase from 10 meters
   ```

3. **Restart app:**
   ```bash
   flutter run
   ```

---

## "Cannot find module 'json-server'"

### Cause
npm dependencies not installed.

### Solution

```bash
cd mock-api
npm install
npm start
```

---

## Still Having Issues?

1. **Check all console logs** — Look for `[API]`, `[WebSocket]`, or error messages
2. **Verify API server is running** — Should see output in terminal
3. **Check ports are open** — `lsof -i :3000` and `lsof -i :3001`
4. **Restart everything:**
   ```bash
   # Terminal 1: Stop API server (Ctrl+C)
   # Terminal 1: Restart API server
   cd mock-api && npm start
   
   # Terminal 2: Stop Flutter app (Ctrl+C)
   # Terminal 2: Restart Flutter app
   flutter run
   ```

5. **Check network connection** — Localhost should work offline
6. **Try on different device** — Emulator vs physical device

---

## Getting Help

If you're still stuck:

1. Check the **console output** for error messages
2. Read the **README.md** for architecture details
3. Check **QUICKSTART.md** for setup steps
4. Review **ARCHITECTURE.md** for how things work

The most common issue is the API server not running. Make sure you have:
- Terminal 1: `cd mock-api && npm start` (API server)
- Terminal 2: `flutter run` (Flutter app)

Both terminals must be open and running.
