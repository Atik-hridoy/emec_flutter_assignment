const { WebSocketServer } = require('ws');

const wss = new WebSocketServer({ port: 3001, host: '0.0.0.0' });

console.log('WebSocket server running on ws://0.0.0.0:3001');

wss.on('connection', (ws) => {
  console.log('Client connected');

  setInterval(() => {
    const statuses = ['PICKED_UP', 'EN_ROUTE', 'DELIVERED'];

    const message = {
      event: 'order_status_updated',
      order_id: 'order-002',
      status: statuses[Math.floor(Math.random() * statuses.length)]
    };

    ws.send(JSON.stringify(message));
  }, 30000); // every 30 sec
});