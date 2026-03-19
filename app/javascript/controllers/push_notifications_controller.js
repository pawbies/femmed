import { Controller } from "@hotwired/stimulus"

function urlBase64ToUint8Array(base64String) {
  const padding = '='.repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  const raw = atob(base64);
  return Uint8Array.from([...raw].map(c => c.charCodeAt(0)));
}

export default class extends Controller {
  static targets = ["button", "status"]

  async connect() {
    // Hide entirely if browser doesn't support push
    if (!('serviceWorker' in navigator) || !('PushManager' in window)) {
      this.element.hidden = true
      return
    }

    this.registration = await navigator.serviceWorker.ready
    await this.updateState()
  }

  async updateState() {
    const subscription = await this.registration.pushManager.getSubscription()
    const permission = Notification.permission

    if (permission === 'denied') {
      this.buttonTarget.disabled = true
      this.buttonTarget.textContent = "Notifications blocked"
      this.statusTarget.textContent = "Enable notifications in your browser settings to use this feature."
    } else if (subscription) {
      this.buttonTarget.textContent = "Unsubscribe"
      this.buttonTarget.dataset.action = "push-notifications#unsubscribe"
      this.statusTarget.textContent = "You're receiving push notifications."
    } else {
      this.buttonTarget.textContent = "Enable push notifications"
      this.buttonTarget.dataset.action = "push-notifications#subscribe"
      this.statusTarget.textContent = ""
    }
  }

  async subscribe() {
    this.buttonTarget.disabled = true
    this.buttonTarget.textContent = "Subscribing…"

    try {
      const vapidPublicKey = document.querySelector('meta[name="vapid-public-key"]').content

      const subscription = await this.registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: urlBase64ToUint8Array(vapidPublicKey)
      })

      await this.syncSubscription(subscription, 'POST')
    } catch (error) {
      if (Notification.permission === 'denied') {
        this.statusTarget.textContent = "Permission denied. Check your browser settings."
      } else {
        this.statusTarget.textContent = "Something went wrong. Please try again."
        console.error("Push subscription failed:", error)
      }
    } finally {
      this.buttonTarget.disabled = false
      await this.updateState()
    }
  }

  async unsubscribe() {
    this.buttonTarget.disabled = true
    this.buttonTarget.textContent = "Unsubscribing…"

    try {
      const subscription = await this.registration.pushManager.getSubscription()

      if (subscription) {
        await this.syncSubscription(subscription, 'DELETE')
        await subscription.unsubscribe()
      }
    } catch (error) {
      this.statusTarget.textContent = "Could not unsubscribe. Please try again."
      console.error("Unsubscribe failed:", error)
    } finally {
      this.buttonTarget.disabled = false
      await this.updateState()
    }
  }

  async syncSubscription(subscription, method) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    const response = await fetch('/push_subscriptions', {
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify(subscription.toJSON())
    })

    if (!response.ok) {
      throw new Error(`Server responded with ${response.status}`)
    }
  }
}
