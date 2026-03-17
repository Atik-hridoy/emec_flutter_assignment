# Railway Deployment Guide

## Quick Deploy to Railway

### Step 1: Push to GitHub
```bash
# Initialize git in mock-api folder
git init
git add .
git commit -m "Initial commit: EMEC Mock API Backend"

# Add your repository
git remote add origin https://github.com/hridoyatik100-dotcom/assignment-backend.git
git branch -M main
git push -u origin main
```

### Step 2: Deploy on Railway
1. Go to [railway.app](https://railway.app)
2. Sign in with GitHub
3. Click "New Project"
4. Select "Deploy from GitHub repo"
5. Choose `assignment-backend` repository
6. Railway will auto-detect Node.js and deploy

### Step 3: Get Your Live URL
After deployment, Railway provides:
- **Live URL**: `https://assignment-backend-production.railway.app`
- **API Endpoint**: `https://assignment-backend-production.railway.app/driver/shift`
- **WebSocket**: `wss://assignment-backend-production.railway.app`

### Step 4: Test Your API
```bash
# Test REST API
curl https://assignment-backend-production.railway.app/driver/shift

# Should return JSON with orders
```

### Step 5: Update Flutter App
In your Flutter project, update `lib/core/api/endpoints.dart`:

```dart
class ApiEndpoints {
  static const String baseUrl = 'https://assignment-backend-production.railway.app';
  static const String webSocketUrl = 'wss://assignment-backend-production.railway.app';
  // ... rest unchanged
}
```

## Environment Variables (Optional)

Railway automatically sets:
- `PORT` - HTTP server port
- `WS_PORT` - WebSocket port (PORT + 1)

## Monitoring

Railway provides:
- ✅ Real-time logs
- ✅ Metrics dashboard  
- ✅ Automatic restarts
- ✅ Custom domains
- ✅ SSL certificates

## Free Tier Limits

Railway free tier includes:
- **500 hours/month** (enough for assignment)
- **1GB RAM**
- **1GB storage**
- **100GB bandwidth**

Perfect for this assignment! 🚀