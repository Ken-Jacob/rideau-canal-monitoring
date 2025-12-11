# RIDEAU CANAL REAL-TIME MONITORING SYSTEM
*(CST8916 – Remote Data & Real-Time Applications)*

## 1. Project Overview
The National Capital Commission (NCC) requires a real-time safety monitoring system for the Rideau Canal Skateway.  
This project implements a cloud-based IoT → Stream Processing → Storage → Dashboard pipeline using Microsoft Azure.

It monitors:
- Ice Thickness (cm)
- Surface Temperature (°C)
- Snow Accumulation (cm)
- External Temperature (°C)

Locations:
- Dow’s Lake
- Fifth Avenue
- NAC

This repository contains all documentation, diagrams, screenshots, and links to the source repositories.

---

## 2. Repository Links

### Documentation Repository (This Repo)
`rideau-canal-monitoring`

### Sensor Simulation Repository
`rideau-canal-sensor-simulation`  
**URL:** [*ADD LINK* ](https://github.com/Ken-Jacob/rideau-canal-sensor-simulation)

### Dashboard Repository
`rideau-canal-dashboard`  
**URL:** [*ADD LINK*](https://github.com/Ken-Jacob/rideau-canal-dashboard/tree/main)

### Live Dashboard
https://<your-app>.azurewebsites.net

---

## 3. Scenario Overview
The Rideau Canal requires real-time monitoring to ensure skater safety.  
The system collects environmental telemetry, processes it, stores it, and visualizes it for decision‑making.

---

## 4. Azure Components

### IoT Hub
- Ingests messages from 3 devices  
- JSON data every 10 seconds  

Screenshots:
- IoT devices  
- IoT Hub metrics  

### Stream Analytics
- 5‑minute tumbling windows  
- Computes averages/min/max  
- Determines safety status  
- Outputs to Cosmos DB + Blob Storage  

Contains `stream-analytics/query.sql`

### Cosmos DB
Stores latest aggregated data.

### Blob Storage
Stores historical JSON for charts.

### Azure App Service
Hosts Node.js REST API + frontend dashboard.

---

## 5. Implementation Overview

### Sensor Simulation
Python script sending telemetry using Azure IoT Device SDK.

### Stream Analytics
Safety logic:
- SAFE: ice ≥ 30cm & surface ≤ -2°C  
- CAUTION: ice ≥ 25cm & surface ≤ 0°C  
- UNSAFE: otherwise  

### Web Dashboard
- Node.js backend  
- HTML/CSS/JS frontend  
- Trend charts using Blob history  
- Auto-refresh every 30s  

---

## 6. Running the System

### Start Sensor Simulator
```bash
python sensor_simulator.py
```

### Confirm IoT Hub Activity  
### Confirm Stream Analytics Running  
### Check Cosmos DB Items  
### Check Blob Storage History  

### Open Dashboard
```bash
npm start
```

---

## 7. Results & Analysis
- Live updates from Cosmos DB  
- Historical trends from Blob Storage  
- Real-time safety classification  
- End‑to‑end cloud pipeline operational  

---

## 8. Challenges & Solutions
- Date formatting → Fixed with compatibility level 1.2  
- App Service deployment → Correct ZIP structure and startup command  
- Empty charts → Run simulator longer to build history  

---

## 9. AI Tools Disclosure
ChatGPT used for debugging, generation, and documentation formatting.   

---
