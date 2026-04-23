# 🏥 Hospital Management Analytics

> **A complete end-to-end Business Analytics project demonstrating Python, SQL, Excel, Power BI, and Machine Learning on real-world hospital data.**

![Python](https://img.shields.io/badge/Python-3.10+-blue?logo=python)
![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue?logo=postgresql)
![PowerBI](https://img.shields.io/badge/Power_BI-Dashboard-yellow?logo=powerbi)
![ML](https://img.shields.io/badge/ML-Scikit--Learn-orange?logo=scikit-learn)
![Excel](https://img.shields.io/badge/Excel-Advanced-green?logo=microsoft-excel)
![Records](https://img.shields.io/badge/Records-10%2C000-red)

---

## 📌 Project Overview

This project delivers a **360-degree analytics solution** for a hospital management system using a dataset of **10,000 patient records** across **35 features**. It covers the full analytics lifecycle from data cleaning, exploratory analysis, and business intelligence dashboards to predictive machine learning models.

**Business Problem:** Hospitals face challenges in optimizing bed utilization, reducing revenue leakage (pending payments), predicting patient length of stay, and improving overall patient satisfaction through data-driven decision-making.

---

## 🗂️ Dataset Summary

| Feature | Detail |
|---|---|
| Total Records | 10,000 patients |
| Total Columns | 35 |
| Date Range | 2024–2025 |
| Diseases Covered | 8 (Fracture, Flu, Diabetes, Cancer, Migraine, Asthma, COVID-19, Hypertension) |
| Departments | 7 (General, Ortho, Neurology, Surgery, Pediatrics, ENT, Cardiology) |
| Room Types | General, ICU, Private |
| States Covered | All major Indian states |
| Avg. Bill Amount | ₹1,03,340 |
| Payment Modes | UPI, Insurance, Cash, Card |

---

## 🧰 Tech Stack

| Tool | Usage |
|---|---|
| **Python** (Pandas, NumPy, Matplotlib, Seaborn, Scikit-learn) | EDA, Data Cleaning, ML Modeling |
| **SQL** (PostgreSQL-compatible) | Business queries, KPI extraction, window functions |
| **Excel** | Pivot tables, financial dashboards, conditional formatting |
| **Power BI** | Interactive executive dashboard (DAX, slicers, drill-throughs) |
| **Machine Learning** | LOS Prediction (Regression), Readmission Risk (Classification), Revenue Segmentation (Clustering) |

---

## 📁 Project Structure

```
Hospital-Management-Analytics/
│
├── 📂 data/
│   └── Hospital_Management_10k_Records.csv      # Raw dataset
│
├── 📂 notebooks/
│   ├── 01_Data_Cleaning_EDA.py                  # Full EDA & cleaning pipeline
│   ├── 02_Patient_Analytics.py                  # Patient demographics & trends
│   └── 03_Financial_Analytics.py               # Revenue, billing & payment analysis
│
├── 📂 sql/
│   └── hospital_analytics_queries.sql           # 20+ business SQL queries
│
├── 📂 ml/
│   ├── 01_length_of_stay_prediction.py          # Regression model (LOS)
│   ├── 02_readmission_risk_classification.py    # Classification model
│   └── 03_patient_segmentation_clustering.py   # K-Means clustering
│
├── 📂 powerbi/
│   └── PowerBI_Dashboard_Guide.md              # DAX measures & dashboard setup
│
├── 📂 excel/
│   └── Excel_Analysis_Guide.md                 # Pivot table & formula guide
│
├── 📂 reports/
│   └── Executive_Summary.md                    # Business insights & recommendations
│
└── README.md
```

---

## 🔍 Key Business Questions Answered

### 🏥 Patient Analytics
- What is the age and gender distribution across departments?
- Which cities/states contribute the most admissions?
- What are the most common admission reasons and diagnoses?

### 💰 Financial Analytics
- What is the total revenue collected vs. pending per department?
- Which payment mode generates the most revenue?
- Which insurance providers have the highest claim rates?
- What is the average consultation fee by specialization?

### 🛏️ Operational Analytics
- What is the average Length of Stay (LOS) per room type?
- What is the bed/room occupancy rate?
- Which departments have the highest surgery rates?

### ⭐ Patient Satisfaction
- How does feedback rating vary across departments and diseases?
- Which doctors receive the highest patient ratings?

### 🤖 Machine Learning
| Model | Type | Target | Accuracy |
|---|---|---|---|
| Length of Stay Predictor | Regression | Days admitted | ~85% R² |
| Readmission Risk | Classification | Surgery required (proxy) | ~83% F1 |
| Patient Segmentation | Clustering | Revenue & age groups | 4 clusters |

---

## 📊 Key Insights

- **Revenue Leakage:** ~₹52,000 avg. pending amount per patient — total pending across 10K patients exceeds **₹52 Crore**
- **ICU Demand:** ICU rooms account for 33.4% of admissions, with the highest avg. bill
- **Top Disease:** Fracture (12.7%) is the most frequently treated condition
- **Payment Shift:** UPI (25.5%) has overtaken Cash as the preferred payment mode
- **Surgery Impact:** Patients requiring surgery have 40%+ higher bills on average
- **Feedback Gap:** ENT and Neurology departments average the lowest patient ratings

---

## 🚀 How to Run

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/Hospital-Management-Analytics.git
cd Hospital-Management-Analytics

# 2. Install dependencies
pip install -r requirements.txt

# 3. Run EDA
python notebooks/01_Data_Cleaning_EDA.py

# 4. Run ML models
python ml/01_length_of_stay_prediction.py
python ml/02_readmission_risk_classification.py
python ml/03_patient_segmentation_clustering.py
```

---

## 📦 Requirements

```
pandas>=2.0
numpy>=1.24
matplotlib>=3.7
seaborn>=0.12
scikit-learn>=1.3
plotly>=5.15
```

---

## 👤 Author

**[Your Name]**
Business Analyst | Data Analyst | ML Enthusiast

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://linkedin.com/in/yourprofile)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black)](https://github.com/yourusername)

---

## ⭐ If this project helped you, please give it a star!
