# EMEC Mock API Server

Mock API server for the EMEC Driver Companion App assignment.

## Endpoints

- `GET /driver/shift` - Get driver's shift data with orders
- `GET /orders/:id` - Get single order details  
- `PATCH /orders/:id/status` - Update order status
- WebSocket on port 3001 - Real-time order updates

## Local Development

```bash
npm install
npm start
```

## Railway Deployment

1. Push this folder to GitHub
2. Connect to Railway
3. Deploy automatically

The server will run on the assigned Railway port and WebSocket will run on PORT+1.

## Environment Variables

- `PORT` - HTTP server port (set by Railway)
- `WS_PORT` - WebSocket port (defaults to PORT+1)

## Features

- JSON Server with custom routes
- WebSocket server for real-time updates
- CORS enabled for cross-origin requests
- Automatic order status updates every 30 seconds