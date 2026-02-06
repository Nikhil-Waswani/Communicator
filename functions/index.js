const functions = require("firebase-functions");

const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

exports.sendNotificationOnMessage = functions.firestore
  .document("Messages/{messageId}")
  .onCreate(async (snap, context) => {
    const messageData = snap.data();
    
    const receiverId = messageData.receiverId;
    const senderId = messageData.senderId;
    const text = messageData.text;

    const db = getFirestore();
    const userDoc = await db.collection("Users").doc(receiverId).get();
    const token = userDoc.exists ? userDoc.data().token : null;

    if (!token) {
      console.log("No FCM token found for user:", receiverId);
      return;
    }

    const payload = {
      notification: {
        title: `New message from ${senderId}`,
        body: text,
      },
    };

    try {
      await getMessaging().sendToDevice(token, payload);
      console.log("Notification sent to:", receiverId);
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });

