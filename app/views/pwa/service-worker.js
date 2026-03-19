// public/service-worker.js

self.addEventListener('push', (event) => {
  const data = event.data?.json() || {};

  const options = {
    body:  data.body  || 'You have a new notification',
    icon:  data.icon  || '/icon-192.png',
    badge: data.badge || '/badge-72.png',
    data:  { url: data.url || '/' }
  };

  event.waitUntil(
    self.registration.showNotification(data.title || 'Notification', options)
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const url = event.notification.data.url;

  event.waitUntil(
    clients.matchAll({ type: 'window' }).then((windowClients) => {
      // Focus existing tab or open new one
      for (const client of windowClients) {
        if (client.url === url && 'focus' in client) return client.focus();
      }
      return clients.openWindow(url);
    })
  );
});
