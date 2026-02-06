// firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyCHTdGbtBBq2zBqecOIgbmD1xIoow48ngQ",
  authDomain: "communicatordb-bf810.firebaseapp.com",
  projectId: "communicatordb-bf810",
  messagingSenderId: "927193034901",
  appId: "1:927193034901:web:34b8279fff70c4c26feb9c"
});

const messaging = firebase.messaging();
