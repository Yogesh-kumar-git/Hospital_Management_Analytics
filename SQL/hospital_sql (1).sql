-- =============================================================================
-- HOSPITAL MANAGEMENT ANALYTICS — SQL
-- Database : PostgreSQL  (import cleaned CSV as table: hospital_data)
-- =============================================================================

-- A1. Total record count and key breakdowns
SELECT
    COUNT(*)                          AS total_patients,
    COUNT(DISTINCT "DoctorID")        AS total_doctors,
    COUNT(DISTINCT "Department")      AS departments,
    COUNT(DISTINCT "Disease")         AS diseases,
    COUNT(DISTINCT "State")           AS states_covered
FROM hospital_data;


-- A2. Overall financial summary
SELECT
    ROUND(SUM("TotalBillAmount"), 2)    AS total_billed,
    ROUND(SUM("AmountPaid"), 2)         AS total_collected,
    ROUND(SUM("PendingAmount"), 2)      AS total_pending,
    ROUND(
        SUM("AmountPaid") * 100.0
        / SUM("TotalBillAmount"), 2
    )                                   AS collection_rate_pct
FROM hospital_data;


-- A3. Admissions by department
SELECT
    "Department",
    COUNT(*) AS patient_count
FROM hospital_data
GROUP BY "Department"
ORDER BY patient_count DESC;


-- A4. Disease frequency
SELECT
    "Disease",
    COUNT(*) AS patient_count
FROM hospital_data
GROUP BY "Disease"
ORDER BY patient_count DESC;


-- A5. Top 10 doctors by patient volume
SELECT
    "DoctorName",
    "Specialization",
    "Department",
    COUNT(*) AS patients_handled
FROM hospital_data
GROUP BY "DoctorName", "Specialization", "Department"
ORDER BY patients_handled DESC
LIMIT 10;


-- A6. Top 10 doctors by revenue generated
SELECT
    "DoctorName",
    "Department",
    ROUND(SUM("TotalBillAmount"), 2) AS total_revenue
FROM hospital_data
GROUP BY "DoctorName", "Department"
ORDER BY total_revenue DESC
LIMIT 10;


-- A7. Average feedback rating by department
SELECT
    "Department",
    ROUND(AVG("FeedbackRating"), 2) AS avg_rating
FROM hospital_data
GROUP BY "Department"
ORDER BY avg_rating DESC;


-- A8. Insured vs Uninsured — collection rate comparison
SELECT
    "InsuranceProvider",
    COUNT(*)                                  AS patients,
    ROUND(AVG("CollectionRate_%"), 2)         AS avg_collection_rate,
    ROUND(AVG("PendingAmount"), 2)            AS avg_pending
FROM hospital_data
GROUP BY "InsuranceProvider" = 'No Insurance'
-- Simpler grouping:
-- GROUP BY CASE WHEN "InsuranceProvider" = 'No Insurance' THEN 'Uninsured' ELSE 'Insured' END

CREATE OR REPLACE VIEW vw_patient_master AS
SELECT
    "PatientID",
    "PatientName",
    "Age",
    "AgeGroup",
    "Gender",
    "City",
    "State",
    "RegistrationDate"::DATE    AS registration_date,
    "DoctorName",
    "Specialization",
    "Department",
    "AdmissionDate"::DATE       AS admission_date,
    "DischargeDate"::DATE       AS discharge_date,
    "LengthOfStay",
    "RoomType",
    "Disease",
    "AdmissionReason",
    "SurgeryRequired",
    "HadSurgery",
    "TotalBillAmount",
    "AmountPaid",
    "PendingAmount",
    "CollectionRate_%",
    "PaymentMode",
    "InsuranceProvider",
    "IsInsured",
    "PaymentStatus",
    "IsPending",
    "FeedbackRating",

    -- Revenue risk bucket — used in leakage page
    CASE
        WHEN "PendingAmount" >= 100000 THEN 'Critical (≥1L)'
        WHEN "PendingAmount" >= 50000  THEN 'High (50K-1L)'
        WHEN "PendingAmount" >= 10000  THEN 'Medium (10K-50K)'
        WHEN "PendingAmount" > 0       THEN 'Low (<10K)'
        ELSE                                'Cleared'
    END AS revenue_risk_flag

FROM hospital_data;


-- ─────────────────────────────────────────────────────────────────────────────
-- VIEW 2: vw_department_summary
-- PURPOSE : Department-level KPIs aggregated
--           Powers: Revenue page — dept revenue bars, collection rate chart
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_department_summary AS
SELECT
    "Department",

    COUNT(*)                                                AS total_patients,
    ROUND(SUM("TotalBillAmount"), 2)                        AS total_billed,
    ROUND(SUM("AmountPaid"), 2)                             AS total_collected,
    ROUND(SUM("PendingAmount"), 2)                          AS total_pending,
    ROUND(
        SUM("AmountPaid") * 100.0
        / NULLIF(SUM("TotalBillAmount"), 0), 2
    )                                                       AS collection_rate_pct,
    ROUND(AVG("TotalBillAmount"), 2)                        AS avg_bill,
    ROUND(AVG("LengthOfStay"), 1)                           AS avg_los_days,
    ROUND(AVG("FeedbackRating"), 2)                         AS avg_rating,
    SUM("HadSurgery")                                       AS surgery_cases,
    ROUND(SUM("HadSurgery") * 100.0 / COUNT(*), 2)          AS surgery_rate_pct,

    -- Revenue share % across all departments (window function)
    ROUND(
        SUM("TotalBillAmount") * 100.0
        / SUM(SUM("TotalBillAmount")) OVER (), 2
    )                                                       AS revenue_share_pct

FROM hospital_data
GROUP BY "Department";


-- ─────────────────────────────────────────────────────────────────────────────
-- VIEW 3: vw_doctor_scorecard
-- PURPOSE : Doctor-level performance metrics with ranking
--           Powers: Doctor Performance page — leaderboard table, scatter plot
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_doctor_scorecard AS
SELECT
    "DoctorID",
    "DoctorName",
    "Specialization",
    "Department",

    COUNT(*)                                            AS total_patients,
    ROUND(AVG("FeedbackRating"), 2)                     AS avg_rating,
    ROUND(SUM("TotalBillAmount"), 2)                    AS total_revenue,
    ROUND(AVG("TotalBillAmount"), 2)                    AS avg_bill_per_patient,
    ROUND(AVG("ConsultationFee"), 2)                    AS avg_consultation_fee,
    SUM("HadSurgery")                                   AS surgeries_performed,

    -- Rank within department by patient rating
    RANK() OVER (
        PARTITION BY "Department"
        ORDER BY AVG("FeedbackRating") DESC
    )                                                   AS rating_rank_in_dept,

    -- Rank hospital-wide by total revenue generated
    RANK() OVER (
        ORDER BY SUM("TotalBillAmount") DESC
    )                                                   AS revenue_rank_overall

FROM hospital_data
GROUP BY "DoctorID", "DoctorName", "Specialization", "Department";


-- ─────────────────────────────────────────────────────────────────────────────
-- VIEW 4: vw_monthly_trends
-- PURPOSE : Month-by-month time series for trend charts
--           Powers: Trend page — monthly revenue line, admissions area chart
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_monthly_trends AS
SELECT
    DATE_TRUNC('month', "BillingDate"::DATE)        AS billing_month,
    TO_CHAR("BillingDate"::DATE, 'Mon YYYY')        AS month_label,
    "Department",

    COUNT(*)                                        AS admissions,
    ROUND(SUM("TotalBillAmount"), 2)                AS monthly_billed,
    ROUND(SUM("AmountPaid"), 2)                     AS monthly_collected,
    ROUND(SUM("PendingAmount"), 2)                  AS monthly_pending,
    ROUND(AVG("TotalBillAmount"), 2)                AS avg_bill,
    ROUND(AVG("FeedbackRating"), 2)                 AS avg_rating,

    -- Month-over-month revenue growth % per department
    ROUND(
        (SUM("TotalBillAmount")
         - LAG(SUM("TotalBillAmount")) OVER (
               PARTITION BY "Department"
               ORDER BY DATE_TRUNC('month', "BillingDate"::DATE)
           )
        ) * 100.0
        / NULLIF(
            LAG(SUM("TotalBillAmount")) OVER (
                PARTITION BY "Department"
                ORDER BY DATE_TRUNC('month', "BillingDate"::DATE)
            ), 0
        ), 2
    )                                               AS mom_growth_pct

FROM hospital_data
WHERE "BillingDate" IS NOT NULL
GROUP BY
    DATE_TRUNC('month', "BillingDate"::DATE),
    TO_CHAR("BillingDate"::DATE, 'Mon YYYY'),
    "Department";


-- ─────────────────────────────────────────────────────────────────────────────
-- VIEW 5: vw_revenue_leakage
-- PURPOSE : Patient-level pending amount drill-down
--           Powers: Revenue Leakage page — leakage table, risk heatmap
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_revenue_leakage AS
SELECT
    "PatientID",
    "PatientName",
    "Age",
    "Department",
    "Disease",
    "RoomType",
    "PaymentMode",
    "InsuranceProvider",
    ROUND("TotalBillAmount", 2)    AS total_bill,
    ROUND("AmountPaid", 2)         AS amount_paid,
    ROUND("PendingAmount", 2)      AS pending_amount,
    ROUND("CollectionRate_%", 2)   AS collection_rate_pct,
    "FeedbackRating",
    "SurgeryRequired",
    CASE
        WHEN "PendingAmount" >= 100000 THEN 'Critical (≥1L)'
        WHEN "PendingAmount" >= 50000  THEN 'High (50K-1L)'
        WHEN "PendingAmount" >= 10000  THEN 'Medium (10K-50K)'
        WHEN "PendingAmount" > 0       THEN 'Low (<10K)'
        ELSE                                'Cleared'
    END                            AS leakage_severity

FROM hospital_data
WHERE "PendingAmount" > 0
ORDER BY "PendingAmount" DESC;


