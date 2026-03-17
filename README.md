# 🚚 EMEC Driver Companion App

> A modern, production-ready Flutter mobile application designed for delivery drivers to manage their shifts efficiently. Built with cutting-edge Flutter 3 architecture, real-time updates, and an intuitive interface that works seamlessly in real-world delivery scenarios.



## 📱 Screenshots


<img width="312" height="690" alt="Screenshot 2026-03-18 035402" src="https://github.com/user-attachments/assets/546f3309-95cc-4169-8307-20059db73a8c" />
<img width="312" height="694" alt="Screenshot 2026-03-18 035448" src="https://github.com/user-attachments/assets/ed7544e2-bf6b-4560-890a-0fe21e19e5b3" />
<img width="310" height="687" alt="Screenshot 2026-03-18 035416" src="https://github.com/user-attachments/assets/34bd1aef-17d0-48db-87e9-c57e300bf4d5" />

## ✨ Key Features

### 🎯 **Core Functionality**
- **📋 Real-time Order Management** - View and update order statuses instantly
- **🗺️ Interactive Route Map** - Visual delivery route with live GPS tracking  
- **📄 Detailed Order View** - Complete customer information and delivery instructions
- **🔄 Live Updates** - WebSocket integration for real-time order status changes
- **📱 Mobile-First Design** - Optimized for one-handed driver operation

### 🛠️ **Technical Excellence**
- **🎨 Material 3 Design** - Modern, accessible UI components
- **⚡ Flutter 3** - Latest stable Flutter with null safety
- **🔧 Riverpod 2** - Robust state management with zero boilerplate
- **🧭 go_router** - Type-safe navigation with deep linking
- **🌐 Real-time WebSocket** - Instant order updates without refresh
- **📍 Live GPS Tracking** - Real-time driver location on map

![Technical Stack](screenshots/tech-stack.png)

## 🚀 Live Demo

- **📱 Flutter App**: Ready to build APK
- **🌐 Backend API**: [https://emec-flutter-assignment.onrender.com](https://emec-flutter-assignment.onrender.com)
- **📡 WebSocket**: `wss://emec-flutter-assignment.onrender.com`

> **Note**: The backend is deployed on Render.com free tier, which may have a cold start delay of ~50 seconds for the first request.

## 🏗️ Architecture Overview

![Architecture Diagram](screenshots/architecture.png)

### State Management: Riverpod 2

The app uses **Riverpod 2** for all state management, ensuring:
- ✅ **No setState** — all shared state flows through providers
- ✅ **Type-safe** — compile-time guarantees on data types  
- ✅ **Testable** — providers can be easily mocked and overridden
- ✅ **Reactive** — automatic UI updates when data changes

### Key Providers Structure

```dart
// API Layer
apiClientProvider          // Dio HTTP client singleton
webSocketClientProvider    // WebSocket connection manager  
shiftRepositoryProvider    // All API calls (zero UI dependencies)

// Feature Providers
orderListNotifierProvider  // Manages order list + WebSocket updates
orderDetailProvider        // Fetches single order details
orderStatusUpdateProvider  // Handles status transitions with loading states
shiftForMapProvider       // Route geometry and order locations
gpsStreamProvider         // Live GPS position updates
```

### Navigation: go_router

- 🎯 **No Navigator.push/pop** — all navigation through go_router
- 🔗 **Deep linking ready** — `/orders`, `/map`, `/order/:id`
- 📱 **Bottom navigation** — seamless switching between screens
- 🛡️ **Type-safe routes** — compile-time route validation

## 📋 API Endpoints

The app connects to a **Node.js + json-server** backend deployed on **Render.com**:

```
GET    /driver/shift           # Get driver's shift with all orders
GET    /orders/:id             # Get specific order details  
PATCH  /orders/:id/status      # Update order status
WS     wss://host              # Real-time order updates
```

### Order Status Lifecycle
```
ASSIGNED → PICKED_UP → EN_ROUTE → DELIVERED
                    ↘ FAILED
```

## 🖥️ Screens Deep Dive

### 1. 📋 Order List Screen (`/orders`)

![Order List Features](screenshots/order-list-features.png)

- **Real-time updates** via WebSocket connection
- **Pull-to-refresh** support for manual sync
- **Status color coding** for quick visual scanning
- **Tap navigation** to order details
- **Loading, error, and empty states** with retry buttons
- **Order count badge** in bottom navigation

### 2. 🗺️ Route Map Screen (`/map`)

![Route Map Features](screenshots/route-map-features.png)

- **OpenStreetMap** integration with flutter_map
- **Numbered markers** showing delivery sequence
- **Route polyline** connecting all delivery points
- **Live driver GPS** marker (updates every 10 seconds)
- **Interactive markers** - tap to see order summary
- **Auto-fit bounds** on initial load

### 3. 📄 Order Detail Screen (`/order/:id`)

![Order Detail Features](screenshots/order-detail-features.png)

- **Complete order information** - customer, address, items
- **Status update buttons** with loading indicators
- **Real-time status sync** from WebSocket
- **Success/error feedback** via SnackBar
- **Delivery time window** and special instructions
- **Total amount** and item breakdown

## 🔄 Real-time Features

### WebSocket Integration

The app maintains a persistent WebSocket connection for instant updates:

```json
{
  "event": "order_status_updated",
  "order_id": "order-002", 
  "status": "EN_ROUTE"
}
```

When received, **all screens update immediately** without manual refresh.

![WebSocket Flow](screenshots/websocket-flow.png)

### Live GPS Tracking

- **📍 Real-time location** updates every 10 seconds
- **🎯 Smooth marker animation** on map
- **🔋 Battery optimized** - uses efficient location settings
- **🛡️ Permission handling** - graceful fallback if denied

## 🛠️ Development Setup

### Prerequisites

- **Flutter 3.0+** ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Dart 3.0+** (included with Flutter)
- **Android Studio / VS Code** with Flutter extensions
- **Node.js 16+** (for local backend development)

### 1. Clone & Install Dependencies

```bash
# Clone the repository
git clone https://github.com/Atik-hridoy/emec_flutter_assignment.git
cd emec_flutter_assignment

# Install Flutter dependencies
flutter pub get
```

### 2. Run with Production Backend (Recommended)

The app is pre-configured to use the deployed backend on Render.com:

```bash
flutter run
```

### 3. Run with Local Backend (Development)

If you want to run the backend locally:

```bash
# Start local mock API server
cd mock-api
npm install
npm start

# Update endpoints to localhost (in lib/core/api/endpoints.dart)
# Then run Flutter app
flutter run
```

### 4. Build APK for Testing

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

## 🧪 Testing

Run the comprehensive test suite:

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Test Coverage

- ✅ **Provider Tests** - Order list, status updates, WebSocket handling
- ✅ **Repository Tests** - API calls, error handling, data parsing  
- ✅ **Widget Tests** - UI components, user interactions
- ✅ **Integration Tests** - End-to-end user flows

![Test Results](screenshots/test-coverage.png)

## 📁 Project Structure

```
lib/
├── 🎯 main.dart                    # App entry point
├── 📱 app.dart                     # MyApp widget & theme
├── core/                           # Shared app infrastructure
│   ├── api/
│   │   ├── 🌐 api_client.dart      # Dio HTTP client
│   │   ├── 📡 websocket_client.dart # WebSocket manager
│   │   └── 🔗 endpoints.dart       # Centralized API URLs
│   ├── models/
│   │   ├── 📦 order.dart           # Order data model
│   │   ├── 👤 driver.dart          # Driver data model  
│   │   └── 📋 shift.dart           # Shift data model
│   ├── repositories/
│   │   └── 🏪 shift_repository.dart # API abstraction layer
│   ├── providers/
│   │   └── 🔧 api_provider.dart    # Riverpod API providers
│   ├── router/
│   │   └── 🧭 app_router.dart      # go_router configuration
│   └── widgets/
│       └── 📱 root_scaffold.dart   # Bottom navigation
├── features/                       # Feature-based modules
│   ├── order_list/
│   │   ├── 📋 order_list_screen.dart
│   │   ├── 🔧 order_list_provider.dart
│   │   └── widgets/
│   │       └── 🎴 order_card.dart
│   ├── route_map/
│   │   ├── 🗺️ route_map_screen.dart
│   │   ├── 🔧 route_map_provider.dart
│   │   └── widgets/
│   │       └── 📍 driver_marker.dart
│   └── order_detail/
│       ├── 📄 order_detail_screen.dart
│       ├── 🔧 order_detail_provider.dart
│       └── widgets/
│           └── 🔘 status_update_button.dart
└── test/                          # Test files
    ├── providers/
    └── widget_test.dart
```

## 🚀 Deployment

### Backend Deployment (Render.com)

The backend is already deployed and running on **Render.com**:

- **🌐 API URL**: `https://emec-flutter-assignment.onrender.com`
- **📡 WebSocket**: `wss://emec-flutter-assignment.onrender.com`
- **⚡ Auto-deploy**: Connected to GitHub for automatic deployments

![Render Deployment](screenshots/render-deployment.png)

### Flutter App Deployment

#### Build Production APK

```bash
# Build optimized APK
flutter build apk --release --shrink

# APK location
build/app/outputs/flutter-apk/app-release.apk
```

#### Build for Web (Optional)

```bash
flutter build web --release
```

## 🔧 Configuration

### Environment Variables

The app uses centralized configuration in `lib/core/api/endpoints.dart`:

```dart
class ApiEndpoints {
  // Production backend on Render.com
  static const String baseUrl = 'https://emec-flutter-assignment.onrender.com';
  static const String webSocketUrl = 'wss://emec-flutter-assignment.onrender.com';
  
  // API endpoints
  static const String getShift = '/driver/shift';
  static const String getOrder = '/orders';
  static const String updateOrderStatus = '/orders';
}
```

### Switching to Local Development

To use local backend during development:

1. Update `endpoints.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:3000';  // Android emulator
static const String webSocketUrl = 'ws://10.0.2.2:3000';
```

2. Start local server:
```bash
cd mock-api && npm start
```

## 🎯 Code Quality Standards

### ✅ Best Practices Implemented

- **🛡️ Null Safety** - No `dynamic` types, proper null handling
- **⚡ Const Constructors** - Used wherever possible for performance
- **🎯 Single Responsibility** - Each widget has one clear purpose
- **🔄 Immutable State** - All models use `copyWith()` for updates
- **🚨 Error Handling** - All async operations have proper error states
- **📱 Responsive Design** - Works on various screen sizes
- **♿ Accessibility** - Semantic labels and proper contrast ratios

### Performance Optimizations

- **🎨 Efficient Rebuilds** - Riverpod prevents unnecessary widget rebuilds
- **📍 GPS Throttling** - Location updates limited to 10-second intervals
- **🗺️ Map Optimization** - Markers and polylines use efficient rendering
- **📡 WebSocket Management** - Automatic reconnection and cleanup
- **🔄 Smart Caching** - API responses cached to reduce network calls

![Performance Metrics](screenshots/performance.png)

## 🔮 Future Enhancements

### Planned Features

1. **📴 Offline Support** - Cache last shift for offline viewing
2. **⏰ ETA Countdown** - Real-time delivery time estimates  
3. **🎬 Animated Transitions** - Smooth marker movement on map
4. **📍 Geofencing** - Auto-update status when reaching locations
5. **🔔 Push Notifications** - Alert drivers of urgent updates
6. **📊 Analytics Dashboard** - Track delivery performance metrics
7. **🌍 Multi-language** - Support for multiple languages
8. **🎨 Theme Customization** - Dark mode and custom themes

### Technical Improvements

- **🧪 Increased Test Coverage** - Target 90%+ code coverage
- **🔄 State Persistence** - Survive app restarts
- **⚡ Performance Monitoring** - Firebase Performance integration
- **🐛 Crash Reporting** - Firebase Crashlytics integration
- **📱 Platform Channels** - Native Android/iOS optimizations

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **🍴 Fork** the repository
2. **🌿 Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **💾 Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **📤 Push** to the branch (`git push origin feature/amazing-feature`)
5. **🔄 Open** a Pull Request

### Development Guidelines

- Follow **Flutter/Dart** style guidelines
- Add **tests** for new features
- Update **documentation** as needed
- Ensure **null safety** compliance
- Use **meaningful commit messages**

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Atik Hridoy**
- GitHub: [@Atik-hridoy](https://github.com/Atik-hridoy)
- Email: [your-email@example.com](mailto:your-email@example.com)

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Riverpod** - For excellent state management
- **OpenStreetMap** - For free map tiles
- **Render.com** - For reliable backend hosting
- **EMEC** - For the assignment opportunity

---

<div align="center">

**Built with ❤️ using Flutter**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Render](https://img.shields.io/badge/Render-46E3B7?style=for-the-badge&logo=render&logoColor=white)

</div>
