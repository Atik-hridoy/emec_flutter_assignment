# EMEC Driver Companion - Mock API Backend

Mock API server for the EMEC Driver Companion App Flutter assignment.

## 🚀 Live Demo

**Deployed on Railway**: [https://assignment-backend-production.railway.app](https://assignment-backend-production.railway.app)

## 📋 API Endpoints

### REST API
- `GET /driver/shift` - Get driver's shift data with all orders
- `GET /orders/:id` - Get single order details  
- `PATCH /orders/:id/status` - Update order status

### WebSocket
- Real-time order status updates every 30 seconds
- Connects on the same domain with WebSocket protocol

## 🛠️ Local Development

### Prerequisites
- Node.js 16+ 
- npm or yarn

### Installation
```bash
# Clone the repository
git clone https://github.com/hridoyatik100-dotcom/assignment-backend.git
cd assignment-backend

# Install dependencies
npm install

# Start the server
npm start
```

The server will run on:
- **HTTP Server**: `http://localhost:3000`
- **WebSocket Server**: `ws://localhost:3001`

### Available Scripts
- `npm start` - Start production server
- `npm run dev` - Start development server with auto-reload

## 📊 API Response Examples

### GET /driver/shift
```json
{
  "driver": {
    "id": "d1",
    "name": "Rahim Chowdhury", 
    "vehicle": "Bike"
  },
  "shift_date": "2025-05-01",
  "route_geometry": {
    "type": "LineString",
    "coordinates": [[90.4125,23.8103], [90.3795,23.8759], ...]
  },
  "orders": [
    {
      "id": "order-001",
      "sequence": 1,
      "status": "ASSIGNED",
      "customer_name": "Ayasha Begum",
      "address": "12 Kemal Ataturk Ave, Banani",
      "lat": 23.7946,
      "lng": 90.4050,
      "time_window_start": "13:00",
      "time_window_end": "15:00",
      "items": ["Laptop bag x1", "Phone charger x2"],
      "delivery_instructions": "Call on arrival. Gate code: 4521.",
      "total_bdt": 2850
    }
  ]
}
```

### WebSocket Message
```json
{
  "event": "order_status_updated",
  "order_id": "order-002", 
  "status": "EN_ROUTE"
}
```

## 🚀 Railway Deployment

This project is configured for automatic Railway deployment.

### Deploy Steps
1. Fork this repository
2. Connect to [Railway](https://railway.app)
3. Deploy automatically
4. Get your live URL

### Environment Variables
- `PORT` - HTTP server port (auto-set by Railway)
- `WS_PORT` - WebSocket port (defaults to PORT+1)

## 🏗️ Project Structure

```
├── server.js          # Main server file (HTTP + WebSocket)
├── db.json           # Mock database
├── package.json      # Dependencies and scripts
├── railway.toml      # Railway deployment config
└── README.md         # This file
```

## 🔧 Technical Details

### Features
- **JSON Server** with custom routes
- **WebSocket Server** for real-time updates  
- **CORS** enabled for cross-origin requests
- **Auto-reconnect** WebSocket with error handling
- **Graceful shutdown** handling

### Order Status Lifecycle
```
ASSIGNED → PICKED_UP → EN_ROUTE → DELIVERED
                    ↘ FAILED
```

### WebSocket Updates
- Sends random status updates every 30 seconds
- Simulates dispatcher updating orders
- Auto-reconnects on connection loss

## 📱 Flutter App

This backend serves the **EMEC Driver Companion** Flutter app.

**Flutter App Repository**: [Main Assignment Repository]

## 🐛 Troubleshooting

### Local Development Issues
- **Port already in use**: Kill processes on ports 3000/3001
- **CORS errors**: Server includes CORS middleware
- **WebSocket connection fails**: Check firewall settings

### Railway Deployment Issues  
- **Build fails**: Check Railway logs for Node.js version
- **WebSocket not working**: Railway auto-handles WebSocket upgrades
- **API not responding**: Check health endpoint `/shift`

## 📄 License

This project is for educational purposes as part of the EMEC Flutter assignment.

## 👨‍💻 Author

**Hridoy Atik**
- GitHub: [@hridoyatik100-dotcom](https://github.com/hridoyatik100-dotcom)

---

**Assignment**: EMEC Driver Companion App - Flutter Technical Assessment