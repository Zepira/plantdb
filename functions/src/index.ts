"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const functions = require("firebase-functions");
import * as admin from "firebase-admin";
import express, { Request, Response } from "express";
import { log } from "firebase-functions/logger";
const cors = require("cors");

// Initialize Firebase Admin SDK
admin.initializeApp();
const db: admin.firestore.Firestore = admin.firestore(); // Explicitly type db as Firestore
const app = express();

// Use CORS to allow requests from your frontend
app.use(cors({ origin: true }));

/**
 * Helper function to parse array-like query parameters.
 * Handles single strings, comma-separated strings, or arrays of strings.
 * @param {string | string[] | undefined} param The query parameter value.
 * @returns {string[] | undefined} An array of parsed strings, or undefined if no valid input.
 */
const parseArrayQuery = (
  param: string | string[] | undefined
): string[] | undefined => {
  if (typeof param === "string") {
    return param
      .split(",")
      .map((s) => s.trim())
      .filter((s) => s.length > 0);
  }
  if (Array.isArray(param)) {
    // Ensure that array elements are treated as strings
    return param.flatMap((s) =>
      typeof s === "string"
        ? s
            .split(",")
            .map((item) => item.trim())
            .filter((item) => item.length > 0)
        : []
    );
  }
  return undefined;
};

// GET /plants: Retrieve plants with optional filters
app.get("/plants", async (req: Request, res: Response) => {
  try {
    let query: admin.firestore.Query<admin.firestore.DocumentData> =
      db.collection("plants");

    // Apply filters based on query parameters
    // Note: Field names in 'where' clauses directly match your Firestore document structure
    // and the 'id' fields from your reference data collections.

    // Filter: plant_type (array-contains-any)
    const plantTypes = parseArrayQuery(
      req.query.plant_type as string | string[] | undefined
    );
    if (plantTypes && plantTypes.length > 0) {
      query = query.where("plantType", "in", plantTypes);
    }

    const light_requirements = parseArrayQuery(
      req.query.light_requirements as string | string[] | undefined
    );
    if (
      typeof req.query.light_requirements === "string" &&
      req.query.light_requirements.length > 0
    ) {
      query = query.where(
        "lightRequirements", // Matches database field name
        "array-contains-any",
        light_requirements
      );
    }

    const water_requirements = parseArrayQuery(
      req.query.water_requirements as string | string[] | undefined
    );
    if (
      typeof req.query.water_requirements === "string" &&
      req.query.water_requirements.length > 0
    ) {
      query = query.where(
        "waterRequirements", // Matches database field name
        "array-contains-any",
        water_requirements
      );
    }

    const climateZones = parseArrayQuery(req.query.climate_zones as string);
    if (climateZones && climateZones.length > 0) {
      query = query.where("climateZones", "==", climateZones);
    }

    const soil_type = parseArrayQuery(
      req.query.soil_type as string | string[] | undefined
    );

    if (soil_type && soil_type.length > 0) {
      query = query.where("soilType", "array-contains-any", soil_type);
    }

    // Filter: mature_size (==) - Added this filter
    if (
      typeof req.query.mature_size === "string" &&
      req.query.mature_size.length > 0
    ) {
      query = query.where("matureSize", "==", req.query.mature_size as string);
    }

    // Filter: bloom_colors (array-contains-any)
    const bloomColors = parseArrayQuery(
      req.query.bloom_colors as string | string[] | undefined
    );
    if (bloomColors && bloomColors.length > 0) {
      query = query.where("bloomColors", "array-contains-any", bloomColors);
    }

    // Existing filter from your original code: canBeGrownFromCuttings
    if (req.query.canBeGrownFromCuttings === "true") {
      // Assumes 'propagation' is a map/object in your plant document
      query = query.where("propagation.canBeGrownFromCuttings", "==", true);
    } else if (req.query.canBeGrownFromCuttings === "false") {
      // Added 'false' case for completeness
      query = query.where("propagation.canBeGrownFromCuttings", "==", false);
    }

    const snapshot = await query.get();
    const plants = snapshot.docs.map(
      (doc: admin.firestore.QueryDocumentSnapshot) => ({
        id: doc.id,
        ...doc.data(),
      })
    );
    res.status(200).json(plants);
  } catch (error) {
    console.error("Error fetching plants:", error);
    res.status(500).json({
      error: "Failed to fetch plants",
      details: error instanceof Error ? error.message : "Unknown error",
    });
  }
});

// GET /plants/:id: Retrieve a single plant by ID
app.get("/plants/:id", async (req: Request, res: Response) => {
  try {
    const doc = await db.collection("plants").doc(req.params.id).get();
    if (!doc.exists) {
      return res.status(404).json({ error: "Plant not found" });
    }
    return res.status(200).json({ id: doc.id, ...doc.data() });
  } catch (error) {
    console.error("Error fetching plant by ID:", error);
    return res.status(500).json({
      error: "Failed to fetch plant by ID",
      details: error instanceof Error ? error.message : "Unknown error",
    });
  }
});

// --- Reference Data Endpoints ---

/**
 * Generic helper function to fetch all documents from a specified Firestore collection.
 * Used for populating filter options.
 * @param {string} collectionName The name of the Firestore collection.
 * @param {express.Response} res The Express response object.
 */
async function getReferenceData(collectionName: string, res: express.Response) {
  try {
    const snapshot = await db.collection(collectionName).get();
    const data = snapshot.docs.map(
      (doc: admin.firestore.QueryDocumentSnapshot) => ({
        id: doc.id,
        ...doc.data(),
      })
    );
    res.status(200).json(data);
  } catch (error) {
    console.error(`Error fetching ${collectionName}:`, error);
    res.status(500).json({
      error: `Failed to fetch ${collectionName}`,
      details: error instanceof Error ? error.message : "Unknown error",
    });
  }
}

// Endpoint for Plant Types
app.get("/plant-types", async (req: Request, res: Response) => {
  await getReferenceData("plant_types", res);
});

// Endpoint for Life Cycle (using the collection name 'life_cycle' from your original code)
app.get("/life-cycle", async (req: Request, res: Response) => {
  await getReferenceData("life_cycle", res);
});

// Endpoint for Light Needs - Changed from /light-requirements to align with Flutter/Database
app.get("/light-requirements", async (req: Request, res: Response) => {
  await getReferenceData("light_requirements", res); // Matches database collection name
});

// Endpoint for Watering Needs - Changed from /water-requirements to align with Flutter/Database
app.get("/water-requirements", async (req: Request, res: Response) => {
  await getReferenceData("water_requirements", res); // Matches database collection name
});

// Endpoint for Climate Zones
app.get("/climate-zones", async (req: Request, res: Response) => {
  await getReferenceData("climate_zones", res);
});

// Endpoint for Soil Types
app.get("/soil-types", async (req: Request, res: Response) => {
  await getReferenceData("soil_types", res);
});

// Export the Express app as a Cloud Function
exports.api = functions.https.onRequest(app);
