
# 🚓 Strategic Crime & Data Analysis for Resource Deployment  
### *Aurora Police Department – Crime & Data Analyst Case Study*

## 🧠 What This Project Is Really About (스토리의 시작)

Police departments are asked to make **time-sensitive decisions** every day:  
**Where should officers be deployed? When should staffing be adjusted? Which areas require immediate attention?**

This project was built to demonstrate **how a Crime & Data Analyst can use SQL and analytics to support those decisions**.

> **My goal with this project** is to show how raw crime data can be transformed into  
> **clear patterns, emerging hotspot insights, and concise monthly summaries**  
> that help command staff and district leadership make informed, data-driven decisions.

This is not a visualization-only project.  
It is a **full analytical workflow** designed to mirror how a **municipal police department** conducts **strategic crime analysis**.

## 🎯 What I Am Demonstrating

- Strategic crime pattern analysis (temporal & spatial)  
- SQL-based ETL and data validation  
- Hotspot and emerging trend detection  
- Real-time and monthly summary reporting  
- Translating analysis into **resource deployment insights**  
- Communicating findings clearly for **non-technical stakeholders**  

## ❓ Core Analytical Questions

1. **When** do crime incidents occur most frequently?  
2. **Where** are incidents concentrated, and which areas are **emerging hotspots**?  
3. **What types of offenses** are changing over time?  
4. How can these insights inform **patrol planning, staffing, and enforcement priorities**?  

## 🗂️ Data Overview

- **Source:** Public city crime incident data (open data portal)  
- **Structure:** RMS-style incident and offense records  
- **Records:** ~342,000 crime records  

## 🛠️ Data Architecture & ETL Workflow

### 1️⃣ Staging Layer – `stg_crime_offenses`
- Raw data ingestion from CSV  
- Minimal transformation  
- Data quality and validation checks  

### 2️⃣ Fact Layer – `fact_crime_offenses`
- Parsed and standardized date/time fields  
- Separation of **incident occurrence date** vs. **reported date**  
- Cleaned geographic and administrative attributes  

### 3️⃣ Analytics Layer – `vw_crime_tableau`
- Derived time dimensions (month, day, hour)  
- Spatial grid fields for hotspot analysis  
- Optimized for Tableau dashboards  

## 🔍 Analysis Framework

### 🔹 Monthly & Real-Time Overview
- Monthly incident trends  
- Month-over-month (MoM) changes  
- Recent 30-day vs. prior 30-day comparisons  

### 🔹 Temporal Pattern Analysis
- Day-of-week patterns  
- Hour-of-day analysis (nighttime focus)  

### 🔹 Spatial Pattern & Hotspot Analysis
- District and Neighborhood concentration  
- Emerging hotspot detection  

### 🔹 Offense Mix & Operational Insights
- Offense category trends  
- Reporting lag analysis  

## 📊 Tableau Dashboard

### 📸 Dashboard Screenshots
*(Add Tableau screenshots here)*

```
/visuals
  ├── tableau_dashboard_overview.png
  ├── monthly_trend_view.png
  └── hotspot_map_view.png
```

## 🧭 Recommendations

- Deploy **targeted patrols** to emerging hotspot areas  
- Adjust **shift schedules** to align with crime peaks  
- Monitor changing offense categories  
- Improve reporting workflows  

## 🧠 Skills Demonstrated

- SQL (ETL, analytics, window functions)  
- Data validation and QA  
- Strategic crime analysis  
- Dashboard-ready data modeling  

## ⚠️ Disclaimer

This project uses publicly available data for educational and portfolio purposes only.
