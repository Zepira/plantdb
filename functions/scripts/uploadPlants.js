const admin = require("firebase-admin");
const fs = require("fs");
const data = require("./data/plant_seed_data.json");

console.log("Starting plant data upload...");

// const data = JSON.parse(
//   fs.readFileSync("./data/plant_seed_data.json", "utf-8")
// );

const serviceAccount = require("../../garden-api-cf2ec-firebase-adminsdk-fbsvc-e3e3937d1a.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: "garden-api-cf2ec",
});

const db = admin.firestore();

async function upload() {
  const collectionRef = db.collection("plants");

  // Step 1: Delete all existing documents in the "plants" collection
  const snapshot = await collectionRef.get();
  const deleteBatch = db.batch();
  snapshot.forEach((doc) => {
    deleteBatch.delete(doc.ref);
  });
  await deleteBatch.commit();
  console.log("✅ Existing plant data deleted successfully!");

  // Step 2: Upload new plant data
  const uploadBatch = db.batch();
  data.forEach((plant) => {
    const docRef = collectionRef.doc(); // auto-ID, or use `.doc(plant.commonName.toLowerCase())`
    uploadBatch.set(docRef, plant);
  });
  await uploadBatch.commit();
  console.log("✅ New plant data uploaded successfully!");
}

upload().catch(console.error);
