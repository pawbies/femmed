import { Controller } from "@hotwired/stimulus"

function urlBase64ToUint8Array(base64String) {
  const padding = '='.repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  const raw = atob(base64);
  return Uint8Array.from([...raw].map(c => c.charCodeAt(0)));
}

async function subscribeToPush() {
  if (!('serviceWorker' in navigator) || !('PushManager' in window)) {
    console.warn('Push notifications not supported');
    return;
  }

  const registration = await navigator.serviceWorker.register('/service-worker.js');
  await navigator.serviceWorker.ready;

  const vapidPublicKey = document.querySelector('meta[name="vapid-public-key"]').content;

  const subscription = await registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: urlBase64ToUint8Array(vapidPublicKey)
  });

  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

  await fetch('/push_subscriptions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': csrfToken
    },
    body: JSON.stringify(subscription.toJSON())
  });
}

// Connects to data-controller="push-notifications"
export default class extends Controller {

  subscribe() {
    subscribeToPush();
  }
}
