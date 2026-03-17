const jsonServer = require('json-server');
const { WebSocketServer } = require('ws');
const path = require('path');

const app = jsonServer.create();
const router = jsonServer.router(path.join(__dirname, 'db.json'));
const middlewares = jsonServer.defaults();

app.use(middlewares);

app.use(jsonServer.rewriter({
  '/driver/shift': '/shift'
}));

app.use(router);

// ✅ IMPORTANT
const PORT = process.env.PORT || 3000;

// Start HTTP server
const server = app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

// ✅ Attach WebSocket AFTER server starts
const wss = new WebSocketServer({ server });

wss.on('connection', (ws) => {
  console.log('Client connected');

  const interval = setInterval(() => {
    const data = {
      event: "order_status_updated",
      order_id: "order-002",
      status: ["PICKED_UP", "EN_ROUTE", "DELIVERED"][
        Math.floor(Math.random() * 3)
      ]
    };

    ws.send(JSON.stringify(data));
  }, 30000);

  ws.on('close', () => {
    clearInterval(interval);
  });
});