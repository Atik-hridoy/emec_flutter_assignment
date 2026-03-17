const jsonServer = require('json-server');
const { WebSocketServer } = require('ws');
const path = require('path');

const server = jsonServer.create();
const router = jsonServer.router(path.join(__dirname, 'db.json'));
const middlewares = jsonServer.defaults();

// Use middlewares
server.use(middlewares);

// Custom routes
server.use(jsonServer.rewriter({
  '/driver/shift': '/shift'
}));

// Use router
server.use(router);

// Get port from environment or default to 3000
const PORT = process.env.PORT || 3000;
const WS_PORT = process.env.WS_PORT || (parseInt(PORT) + 1);

// Start HTTP server
const httpServer = server.listen(PORT, '0.0.0.0', () => {
  console.log(`JSON Server is running on port ${PORT}`);
  console.log(`Available endpoints:`);
  console.log(`  GET /driver/shift`);
  console.log(`  GET /orders/:id`);
  console.log(`  PATCH /orders/:id/status`);
});

// Start WebSocket server
const wss = new WebSocketServer({ 
  port: WS_PORT,
  host: '0.0.0.0'
});

console.log(`WebSocket server running on ws://0.0.0.0:${WS_PORT}`);

wss.on('connection', (ws) => {
  console.log('Client connected to WebSocket');

  // Send order status updates every 30 seconds
  const interval = setInterval(() => {
    const statuses = ['PICKED_UP', 'EN_ROUTE', 'DELIVERED'];
    const randomStatus = statuses[Math.floor(Math.random() * statuses.length)];
    
    const message = {
      event: 'order_status_updated',
      order_id: 'order-002',
      status: randomStatus
    };

    if (ws.readyState === 1) {
      ws.send(JSON.stringify(message));
      console.log(`Sent WebSocket message: ${JSON.stringify(message)}`);
    }
  }, 30000);

  ws.on('close', () => {
    console.log('Client disconnected from WebSocket');
    clearInterval(interval);
  });

  ws.on('error', (error) => {
    console.error('WebSocket error:', error);
    clearInterval(interval);
  });
});

// Handle graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  httpServer.close(() => {
    console.log('HTTP server closed');
    wss.close(() => {
      console.log('WebSocket server closed');
      process.exit(0);
    });
  });
});