import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as express from 'express';
import * as cors from 'cors';

admin.initializeApp();
const db = admin.firestore();

const app = express();
app.use(cors({ origin: true }));

// GET /plants with optional filters
app.get('/plants', async (req, res) => {
  try {
    let query: FirebaseFirestore.Query = db.collection('plants');

    if (req.query.flowerColor) {
      query = query.where('flowerColours', 'array-contains', req.query.flowerColor);
    }

    if (req.query.zone) {
      query = query.where('climateZones', 'array-contains', parseInt(req.query.zone as string));
    }

    if (req.query.canBeGrownFromCuttings === 'true') {
      query = query.where('propagation.canBeGrownFromCuttings', '==', true);
    }

    const snapshot = await query.get();
    const plants = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.status(200).json(plants);
  } catch (error) {
    console.error('Error fetching plants:', error);
    res.status(500).json({ error: 'Failed to fetch plants' });
  }
});

// GET /plants/:id
app.get('/plants/:id', async (req, res) => {
  try {
    const doc = await db.collection('plants').doc(req.params.id).get();

    if (!doc.exists) {
      return res.status(404).json({ error: 'Plant not found' });
    }

    return res.status(200).json({ id: doc.id, ...doc.data() });
  } catch (error) {
    console.error('Error fetching plant:', error);
    return res.status(500).json({ error: 'Failed to fetch plant' });
  }
});

exports.api = functions.https.onRequest(app);
