-- 1. Doctors with most appointments per month
SELECT 
    p.first_name + ' ' + p.last_name AS doctor_name,
    dd.specialization,
    FORMAT(a.appointment_start, 'yyyy-MM') AS month,
    COUNT(*) AS appointment_count
FROM ohc.appointment a
INNER JOIN ohc.person p ON a.doctor_id = p.person_id
INNER JOIN ohc.doctor_details dd ON p.person_id = dd.person_id
WHERE a.status = 'completed'
GROUP BY p.first_name, p.last_name, dd.specialization, FORMAT(a.appointment_start, 'yyyy-MM')
ORDER BY month DESC, appointment_count DESC;

-- 2. Top diagnoses per year
SELECT 
    YEAR(mr.created_at) AS year,
    mr.diagnosis_code,
    mr.diagnosis,
    COUNT(*) AS occurrence_count
FROM ohc.medical_record mr
WHERE mr.diagnosis_code IS NOT NULL
GROUP BY YEAR(mr.created_at), mr.diagnosis_code, mr.diagnosis
ORDER BY year DESC, occurrence_count DESC;

-- 3. Patient visit frequency
SELECT 
    p.first_name + ' ' + p.last_name AS patient_name,
    COUNT(a.appointment_id) AS total_visits,
    COUNT(CASE WHEN a.status = 'completed' THEN 1 END) AS completed_visits,
    COUNT(CASE WHEN a.status = 'cancelled' THEN 1 END) AS cancelled_visits,
    COUNT(CASE WHEN a.status = 'no_show' THEN 1 END) AS no_shows,
    MIN(a.appointment_start) AS first_visit,
    MAX(a.appointment_start) AS last_visit
FROM ohc.person p
INNER JOIN ohc.patient_details pd ON p.person_id = pd.person_id
LEFT JOIN ohc.appointment a ON p.person_id = a.patient_id
GROUP BY p.person_id, p.first_name, p.last_name
ORDER BY total_visits DESC;

-- 4. Clinic utilization
SELECT 
    c.clinic_name,
    c.city,
    COUNT(a.appointment_id) AS total_appointments,
    COUNT(CASE WHEN a.status = 'completed' THEN 1 END) AS completed,
    COUNT(CASE WHEN a.status = 'cancelled' THEN 1 END) AS cancelled,
    CAST(COUNT(CASE WHEN a.status = 'completed' THEN 1 END) * 100.0 / 
         NULLIF(COUNT(a.appointment_id), 0) AS DECIMAL(5,2)) AS completion_rate
FROM ohc.clinic c
LEFT JOIN ohc.appointment a ON c.clinic_id = a.clinic_id
GROUP BY c.clinic_id, c.clinic_name, c.city
ORDER BY total_appointments DESC;

-- 5. Prescription patterns by doctor
SELECT 
    p.first_name + ' ' + p.last_name AS doctor_name,
    dd.specialization,
    rx.medicine_name,
    COUNT(*) AS times_prescribed
FROM ohc.prescription rx
INNER JOIN ohc.medical_record mr ON rx.record_id = mr.record_id
INNER JOIN ohc.person p ON mr.doctor_id = p.person_id
INNER JOIN ohc.doctor_details dd ON p.person_id = dd.person_id
GROUP BY p.first_name, p.last_name, dd.specialization, rx.medicine_name
ORDER BY doctor_name, times_prescribed DESC;

-- 6. Patients with abnormal lab results
SELECT 
    p.first_name + ' ' + p.last_name AS patient_name,
    lr.test_name,
    lr.result_value,
    lr.reference_range,
    lr.notes,
    lr.tested_at
FROM ohc.lab_result lr
INNER JOIN ohc.medical_record mr ON lr.record_id = mr.record_id
INNER JOIN ohc.person p ON mr.patient_id = p.person_id
WHERE lr.is_abnormal = 1
ORDER BY lr.tested_at DESC;

-- 7. Average appointment duration by doctor
SELECT 
    p.first_name + ' ' + p.last_name AS doctor_name,
    dd.specialization,
    COUNT(*) AS total_appointments,
    AVG(DATEDIFF(MINUTE, a.appointment_start, a.appointment_end)) AS avg_duration_minutes
FROM ohc.appointment a
INNER JOIN ohc.person p ON a.doctor_id = p.person_id
INNER JOIN ohc.doctor_details dd ON p.person_id = dd.person_id
WHERE a.status = 'completed'
GROUP BY p.first_name, p.last_name, dd.specialization
ORDER BY avg_duration_minutes DESC;

-- 8. Patients needing follow-up
SELECT 
    p.first_name + ' ' + p.last_name AS patient_name,
    pd.first_name + ' ' + pd.last_name AS doctor_name,
    mr.diagnosis,
    mr.follow_up_date,
    DATEDIFF(DAY, GETDATE(), mr.follow_up_date) AS days_until_followup
FROM ohc.medical_record mr
INNER JOIN ohc.person p ON mr.patient_id = p.person_id
INNER JOIN ohc.person pd ON mr.doctor_id = pd.person_id
WHERE mr.follow_up_required = 1
  AND mr.follow_up_date >= CAST(GETDATE() AS DATE)
ORDER BY mr.follow_up_date;

-- Rank doctors by appointment count
SELECT 
    p.first_name + ' ' + p.last_name AS doctor_name,
    dd.specialization,
    COUNT(*) AS appointment_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_overall,
    RANK() OVER (PARTITION BY dd.specialization ORDER BY COUNT(*) DESC) AS rank_in_specialty
FROM ohc.appointment a
INNER JOIN ohc.person p ON a.doctor_id = p.person_id
INNER JOIN ohc.doctor_details dd ON p.person_id = dd.person_id
WHERE a.status = 'completed'
GROUP BY p.first_name, p.last_name, dd.specialization;

-- Patient visit timeline with running total
SELECT 
    p.first_name + ' ' + p.last_name AS patient_name,
    a.appointment_start,
    a.status,
    ROW_NUMBER() OVER (PARTITION BY a.patient_id ORDER BY a.appointment_start) AS visit_number,
    COUNT(*) OVER (PARTITION BY a.patient_id ORDER BY a.appointment_start) AS running_total
FROM ohc.appointment a
INNER JOIN ohc.person p ON a.patient_id = p.person_id
ORDER BY patient_name, a.appointment_start;
