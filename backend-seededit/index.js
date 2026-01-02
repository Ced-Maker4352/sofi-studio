import express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import fetch from "node-fetch";

const app = express();
app.use(cors());
app.use(bodyParser.json({ limit: "50mb" }));

// 🔐 YOUR MODELSLAB KEY
const API_KEY = "vg7AsubsEQfYY4PZVm2yjLvNk5NgzawWohWTWULpr7jHGDhCMZNDnwdAJX8A";

// SeedEdit I2I endpoint
const ML_ENDPOINT = "https://modelslab.com/api/v1/images/image-to-image";

app.post("/generate", async (req, res) => {
  try {
    const { prompt, image } = req.body;

    if (!prompt) {
      return res.status(400).json({ error: "Missing prompt" });
    }

    const payload = {
      prompt,
      model_id: "seededit-i2i",
      key: API_KEY,
      init_image: image || null, // base64 encoded optional
    };

    const response = await fetch(ML_ENDPOINT, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    const data = await response.json();

    if (!response.ok || !data.output || !data.output[0]) {
      return res.status(500).json({
        error: data.error || "ModelsLab returned no image.",
      });
    }

    return res.json({
      success: true,
      imageUrl: data.output[0],
    });
  } catch (err) {
    console.error("Backend error:", err);
    return res.status(500).json({ error: err.message });
  }
});

app.get("/", (req, res) => {
  res.send("SeedEdit backend running.");
});

app.listen(8080, () => {
  console.log("Backend running on port 8080");
});
