# Railway Deployment Guide

## Step 1: Prepare Repository

1. Make sure your `mock-api` folder has these files:
   - ✅ `server.js` (combined HTTP + WebSocket server)
   - ✅ `package.json` (with correct start script)
   - ✅ `db.json` (your data)
   - ✅ `railway.toml` (Railway config)

## Step 2: Deploy to Railway

1. Go to [railway.app](https://railway.app)
2. Sign up with GitHub
3. Click "New Project"
4. Select "Deploy from GitHub repo"
5. Choose your repository
6. Select the `mock-api` folder as root directory
7. Railway will automatically detect Node.js and deploy

## Step 3: Get Your URLs

After deployment, Railway will give you:
- **HTTP URL**: `https://your-app-name.railway.app`
- **WebSocket URL**: `wss://your-app-name.railway.app` (same domain, different protocol)

## Step 4: Update Flutter App

Update `lib/core/api/endpoints.dart`:

```dart
class ApiEndpoints {
  // Replace with your Railway URL
  static const String baseUrl = 'https://your-app-name.railway.app';
  static const String webSocketUrl = 'wss://your-app-name.railway.app';
  
  // ... rest of the code
}
```

## Step 5: Test Deployment

Test these URLs in browser:
- `https://your-app-name.railway.app/shift` - Should return JSON data
- `https://your-app-name.railway.app/driver/shift` - Should return same data
- `https://your-app-name.railway.app/orders` - Should return orders array

## Step 6: Build APK

```bash
flutter build apk --release
```

Your APK will now connect to the deployed Railway API!

## Troubleshooting

- **Build fails**: Check Railway logs for errors
- **WebSocket not working**: Railway automatically handles WebSocket upgrades
- **CORS issues**: The server includes CORS middleware
- **Port issues**: Railway automatically assigns ports

## Cost

Railway free tier includes:
- ✅ 500 hours/month (enough for assignment)
- ✅ Custom domain
- ✅ Automatic HTTPS
- ✅ WebSocket support