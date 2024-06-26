const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();

exports.syncOut = functions.https.onCall(async (data, context) => {
  const { userId, val } = data;
  console.log(data);
  try {
    await db.collection("users").doc(userId).update({ isSynced: val });
    console.log("===>> success");
    return true;
  } catch (error) {
    console.log("===>> failier ", error);
    return false;
  }
});

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
