-- ============================================================================
-- SECTION 8: VIEWS
-- ============================================================================

CREATE VIEW ohc.v_patient_full AS
SELECT 
    p.person_id,
    p.first_name,
    p.last_name,
    p.first_name + N' ' + p.last_name AS full_name,
    p.date_of_birth,
    DATEDIFF(YEAR, p.date_of_birth, GETDATE()) AS age,
    p.gender,
    pd.blood_type,
    pd.allergies,
    pd.medical_conditions,
    pd.insurance_provider,
    pd.insurance_number,
    (SELECT TOP 1 contact_value 
     FROM ohc.contact c 
     WHERE c.person_id = p.person_id 
       AND c.contact_type = 'email' 
       AND c.is_primary = 1) AS primary_email,
    (SELECT TOP 1 contact_value 
     FROM ohc.contact c 
     WHERE c.person_id = p.person_id 
       AND c.contact_type = 'phone' 
       AND c.is_primary = 1) AS primary_phone,
    (SELECT TOP 1 CONCAT(address_line1, N', ', city) 
     FROM ohc.address a 
     WHERE a.person_id = p.person_id 
       AND a.is_primary = 1) AS primary_address,
    p.created_at,
    p.is_active
FROM ohc.person p
INNER JOIN ohc.person_role pr ON p.person_id = pr.person_id
INNER JOIN ohc.role r ON pr.role_id = r.role_id
INNER JOIN ohc.patient_details pd ON p.person_id = pd.person_id
WHERE r.role_name = 'patient'
  AND pr.is_active = 1;
GO

CREATE VIEW ohc.v_doctor_full AS
SELECT 
    p.person_id,
    p.first_name,
    p.last_name,
    p.first_name + N' ' + p.last_name AS full_name,
    dd.specialization,
    dd.license_number,
    dd.years_of_experience,
    dd.qualification,
    (SELECT TOP 1 contact_value 
     FROM ohc.contact c 
     WHERE c.person_id = p.person_id 
       AND c.contact_type = 'email' 
       AND c.context = 'professional') AS professional_email,
    (SELECT TOP 1 contact_value 
     FROM ohc.contact c 
     WHERE c.person_id = p.person_id 
       AND c.contact_type = 'phone' 
       AND c.context = 'professional') AS professional_phone,
    (SELECT STRING_AGG(cl.clinic_name, N', ') 
     FROM ohc.doctor_clinic dc
     INNER JOIN ohc.clinic cl ON dc.clinic_id = cl.clinic_id
     WHERE dc.doctor_id = p.person_id
       AND dc.is_active = 1) AS clinics,
    p.created_at,
    p.is_active
FROM ohc.person p
INNER JOIN ohc.person_role pr ON p.person_id = pr.person_id
INNER JOIN ohc.role r ON pr.role_id = r.role_id
INNER JOIN ohc.doctor_details dd ON p.person_id = dd.person_id
WHERE r.role_name = 'doctor'
  AND pr.is_active = 1;
GO

CREATE VIEW ohc.v_doctor_schedule AS
SELECT 
    p.person_id AS doctor_id,
    p.first_name + N' ' + p.last_name AS doctor_name,
    dd.specialization,
    c.clinic_id,
    c.clinic_name,
    c.city AS clinic_city,
    dc.day_of_week,
    CASE dc.day_of_week
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS day_name,
    dc.start_time,
    dc.end_time,
    DATEDIFF(HOUR, dc.start_time, dc.end_time) AS working_hours,
    dc.is_active
FROM ohc.doctor_clinic dc
INNER JOIN ohc.person p ON dc.doctor_id = p.person_id
INNER JOIN ohc.doctor_details dd ON p.person_id = dd.person_id
INNER JOIN ohc.clinic c ON dc.clinic_id = c.clinic_id;
GO

CREATE VIEW ohc.v_appointment_details AS
SELECT 
    a.appointment_id,
    a.patient_id,
    pp.first_name + N' ' + pp.last_name AS patient_name,
    a.doctor_id,
    pd.first_name + N' ' + pd.last_name AS doctor_name,
    dd.specialization,
    a.clinic_id,
    c.clinic_name,
    c.city AS clinic_city,
    a.appointment_start,
    a.appointment_end,
    DATEDIFF(MINUTE, a.appointment_start, a.appointment_end) AS duration_minutes,
    a.status,
    a.reason,
    a.notes,
    a.created_at
FROM ohc.appointment a
INNER JOIN ohc.person pp ON a.patient_id = pp.person_id
INNER JOIN ohc.person pd ON a.doctor_id = pd.person_id
INNER JOIN ohc.doctor_details dd ON pd.person_id = dd.person_id
INNER JOIN ohc.clinic c ON a.clinic_id = c.clinic_id;
GO

CREATE VIEW ohc.v_patient_medical_history AS
SELECT 
    mr.record_id,
    mr.patient_id,
    pp.first_name + N' ' + pp.last_name AS patient_name,
    mr.doctor_id,
    pd.first_name + N' ' + pd.last_name AS doctor_name,
    dd.specialization,
    mr.diagnosis,
    mr.diagnosis_code,
    mr.symptoms,
    mr.treatment_plan,
    mr.follow_up_required,
    mr.follow_up_date,
    mr.created_at AS record_date,
    (SELECT COUNT(*) FROM ohc.prescription rx WHERE rx.record_id = mr.record_id) AS prescription_count
FROM ohc.medical_record mr
INNER JOIN ohc.person pp ON mr.patient_id = pp.person_id
INNER JOIN ohc.person pd ON mr.doctor_id = pd.person_id
INNER JOIN ohc.doctor_details dd ON pd.person_id = dd.person_id
WHERE mr.is_confidential = 0;
GO

CREATE VIEW ohc.v_prescription_details AS
SELECT 
    rx.prescription_id,
    mr.record_id,
    mr.patient_id,
    pp.first_name + N' ' + pp.last_name AS patient_name,
    mr.doctor_id,
    pd.first_name + N' ' + pd.last_name AS prescribing_doctor,
    mr.diagnosis,
    rx.medicine_name,
    m.generic_name,
    m.form AS medicine_form,
    rx.dosage,
    rx.frequency,
    rx.duration_days,
    rx.quantity,
    rx.instructions,
    rx.refills_allowed,
    rx.refills_used,
    rx.refills_allowed - rx.refills_used AS refills_remaining,
    rx.is_active,
    rx.created_at AS prescribed_date
FROM ohc.prescription rx
INNER JOIN ohc.medical_record mr ON rx.record_id = mr.record_id
INNER JOIN ohc.person pp ON mr.patient_id = pp.person_id
INNER JOIN ohc.person pd ON mr.doctor_id = pd.person_id
LEFT JOIN ohc.medicine m ON rx.medicine_id = m.medicine_id;
GO

CREATE VIEW ohc.v_user_info AS
SELECT 
    ua.user_id,
    ua.username,
    ua.email,
    p.first_name,
    p.last_name,
    p.first_name + N' ' + p.last_name AS full_name,
    STRING_AGG(r.role_name, ', ') AS roles,
    ua.is_active,
    ua.is_locked,
    ua.last_login,
    ua.created_at
FROM ohc.user_account ua
INNER JOIN ohc.person p ON ua.person_id = p.person_id
INNER JOIN ohc.person_role pr ON p.person_id = pr.person_id
INNER JOIN ohc.role r ON pr.role_id = r.role_id
WHERE pr.is_active = 1
GROUP BY 
    ua.user_id, ua.username, ua.email, 
    p.first_name, p.last_name,
    ua.is_active, ua.is_locked, ua.last_login, ua.created_at;
GO

CREATE VIEW ohc.v_active_sessions AS
SELECT 
    us.session_id,
    ua.username,
    p.first_name + N' ' + p.last_name AS full_name,
    us.ip_address,
    us.created_at AS session_started,
    us.expires_at,
    DATEDIFF(MINUTE, us.created_at, GETDATE()) AS duration_minutes
FROM ohc.user_session us
INNER JOIN ohc.user_account ua ON us.user_id = ua.user_id
INNER JOIN ohc.person p ON ua.person_id = p.person_id
WHERE us.is_active = 1 
  AND us.expires_at > GETDATE();
GO

CREATE VIEW ohc.v_patient_vitals AS
SELECT 
    vs.vital_id,
    mr.patient_id,
    p.first_name + N' ' + p.last_name AS patient_name,
    vs.blood_pressure_sys,
    vs.blood_pressure_dia,
    CAST(vs.blood_pressure_sys AS VARCHAR) + '/' + CAST(vs.blood_pressure_dia AS VARCHAR) AS blood_pressure,
    vs.heart_rate,
    vs.temperature,
    vs.respiratory_rate,
    vs.oxygen_saturation,
    vs.weight_kg,
    vs.height_cm,
    CASE 
        WHEN vs.weight_kg IS NOT NULL AND vs.height_cm IS NOT NULL 
        THEN ROUND(vs.weight_kg / POWER(vs.height_cm / 100.0, 2), 1)
        ELSE NULL 
    END AS bmi,
    vs.measured_at
FROM ohc.vital_signs vs
INNER JOIN ohc.medical_record mr ON vs.record_id = mr.record_id
INNER JOIN ohc.person p ON mr.patient_id = p.person_id;
GO