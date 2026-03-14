// Importa los scripts de Firebase (usa la versión que tengas)
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

// Inicializa Firebase con tus opciones de Web
firebase.initializeApp({
  apiKey: "AIzaSyBceyovVMjfUseX5B05Ys9rXLLoYRaMoOk",
  authDomain: "my-project-de-entrega.firebaseapp.com",
  projectId: "my-project-de-entrega",
  storageBucket: "my-project-de-entrega.firebasestorage.app",
  messagingSenderId: "404770600917",
  appId: "1:404770600917:web:3f6259817b664ec4382f5c",
  measurementId: "G-XWW7EY9LBY"
});

// Inicializa Firebase Cloud Messaging
const messaging = firebase.messaging();

// Evento para manejar notificaciones cuando la app está en background
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification?.title || 'Notificación';
  const notificationOptions = {
    body: payload.notification?.body || '',
    icon: '/icons/icon-192.png', // Opcional: tu icono de notificación
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});