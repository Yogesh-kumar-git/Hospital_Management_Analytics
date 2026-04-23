select *from hospital_data;
CREATE VIEW department_revenue AS
SELECT 
    Department,
    ROUND(SUM(TotalBillAmount)) AS total_revenue
FROM hospital_data
GROUP BY Department;
SELECT * FROM department_revenue;
CREATE VIEW disease_analysis AS
SELECT 
    Disease,
    COUNT(*) AS patient_count,
    ROUND(AVG(LengthOfStay), 2) AS avg_stay
FROM hospital_data
GROUP BY Disease;
CREATE VIEW room_utilization AS
SELECT 
    RoomType,
    COUNT(*) AS usage_count,
    ROUND(AVG(LengthOfStay), 2) AS avg_stay
FROM hospital_data
GROUP BY RoomType;

CREATE VIEW payment_mode_analysis AS
SELECT 
    PaymentMode,
    COUNT(*) AS transactions,
    ROUND(SUM(TotalBillAmount)) AS total_amount
FROM hospital_data
GROUP BY PaymentMode;

CREATE VIEW pending_cases AS
SELECT 
    PatientID,
    PatientName,
    Department,
    PendingAmount
FROM hospital_data
WHERE PendingAmount > 0
ORDER BY PendingAmount DESC;

CREATE VIEW monthly_revenue AS
SELECT 
    DATE_TRUNC('month', BillingDate) AS month,
    ROUND(SUM(TotalBillAmount)) AS revenue
FROM hospital_data
GROUP BY month
ORDER BY month;

CREATE VIEW surgery_analysis AS
SELECT 
    HadSurgery,
    COUNT(*) AS patient_count,
    ROUND(AVG(TotalBillAmount)) AS avg_cost
FROM hospital_data
GROUP BY HadSurgery;

CREATE VIEW satisfaction_analysis AS
SELECT 
    Department,
    ROUND(AVG(FeedbackRating), 2) AS avg_rating
FROM hospital_data
GROUP BY Department;