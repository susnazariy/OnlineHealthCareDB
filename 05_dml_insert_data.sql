-- ============================================================================
-- SAMPLE DATA FOR ONLINE HEALTHCARE SYSTEM
-- Comprehensive, Valid, and Consistent English Data
-- ============================================================================

USE OnlineHealthCare;
GO

-- Clear existing data (in correct order due to FK constraints)
DELETE FROM ohc.lab_result;
DELETE FROM ohc.vital_signs;
DELETE FROM ohc.prescription;
DELETE FROM ohc.medical_record;
DELETE FROM ohc.access_log;
DELETE FROM ohc.password_history;
DELETE FROM ohc.user_session;
DELETE FROM ohc.user_account;
DELETE FROM ohc.appointment;
DELETE FROM ohc.doctor_clinic;
DELETE FROM ohc.clinic;
DELETE FROM ohc.doctor_details;
DELETE FROM ohc.patient_details;
DELETE FROM ohc.address;
DELETE FROM ohc.contact;
DELETE FROM ohc.person_role;
DELETE FROM ohc.person;
DELETE FROM ohc.medicine;
GO

-- Reset identity seeds
DBCC CHECKIDENT ('ohc.person', RESEED, 0);
DBCC CHECKIDENT ('ohc.contact', RESEED, 0);
DBCC CHECKIDENT ('ohc.address', RESEED, 0);
DBCC CHECKIDENT ('ohc.clinic', RESEED, 0);
DBCC CHECKIDENT ('ohc.doctor_clinic', RESEED, 0);
DBCC CHECKIDENT ('ohc.appointment', RESEED, 0);
DBCC CHECKIDENT ('ohc.user_account', RESEED, 0);
DBCC CHECKIDENT ('ohc.user_session', RESEED, 0);
DBCC CHECKIDENT ('ohc.access_log', RESEED, 0);
DBCC CHECKIDENT ('ohc.password_history', RESEED, 0);
DBCC CHECKIDENT ('ohc.medical_record', RESEED, 0);
DBCC CHECKIDENT ('ohc.prescription', RESEED, 0);
DBCC CHECKIDENT ('ohc.vital_signs', RESEED, 0);
DBCC CHECKIDENT ('ohc.lab_result', RESEED, 0);
DBCC CHECKIDENT ('ohc.medicine', RESEED, 0);
GO

-- ============================================================================
-- SECTION 1: PERSONS (25 people)
-- ============================================================================

INSERT INTO ohc.person (first_name, last_name, date_of_birth, gender) VALUES
    -- Doctors (IDs 1-6)
    (N'Robert', N'Williams', '1975-03-15', 'Male'),
    (N'Sarah', N'Johnson', '1980-07-22', 'Female'),
    (N'Michael', N'Chen', '1972-11-08', 'Male'),
    (N'Emily', N'Davis', '1985-04-30', 'Female'),
    (N'James', N'Anderson', '1968-09-12', 'Male'),
    (N'Lisa', N'Thompson', '1978-12-05', 'Female'),
    
    -- Nurses (IDs 7-9)
    (N'Jennifer', N'Martinez', '1990-02-18', 'Female'),
    (N'David', N'Garcia', '1988-06-25', 'Male'),
    (N'Amanda', N'Wilson', '1992-08-14', 'Female'),
    
    -- Receptionists (IDs 10-11)
    (N'Michelle', N'Brown', '1995-01-20', 'Female'),
    (N'Kevin', N'Taylor', '1993-05-11', 'Male'),
    
    -- Admin (ID 12)
    (N'Christopher', N'Moore', '1982-10-03', 'Male'),
    
    -- Patients (IDs 13-25)
    (N'Emma', N'Jackson', '1988-03-25', 'Female'),
    (N'William', N'White', '1965-07-14', 'Male'),
    (N'Olivia', N'Harris', '1992-11-30', 'Female'),
    (N'Alexander', N'Martin', '1978-04-08', 'Male'),
    (N'Sophia', N'Robinson', '1995-09-17', 'Female'),
    (N'Daniel', N'Clark', '1970-12-22', 'Male'),
    (N'Isabella', N'Lewis', '1985-06-05', 'Female'),
    (N'Matthew', N'Walker', '1990-01-28', 'Male'),
    (N'Ava', N'Hall', '2000-08-12', 'Female'),
    (N'Ethan', N'Allen', '1958-02-19', 'Male'),
    (N'Mia', N'Young', '1998-10-07', 'Female'),
    (N'Benjamin', N'King', '1983-05-30', 'Male'),
    (N'Charlotte', N'Wright', '1975-03-14', 'Female');
GO

-- ============================================================================
-- SECTION 2: PERSON ROLES
-- ============================================================================

INSERT INTO ohc.person_role (person_id, role_id, notes) VALUES
    -- Doctors
    (1, (SELECT role_id FROM ohc.role WHERE role_name = 'doctor'), 'Chief Cardiologist'),
    (2, (SELECT role_id FROM ohc.role WHERE role_name = 'doctor'), 'Senior Neurologist'),
    (3, (SELECT role_id FROM ohc.role WHERE role_name = 'doctor'), 'Orthopedic Surgeon'),
    (4, (SELECT role_id FROM ohc.role WHERE role_name = 'doctor'), 'Pediatrician'),
    (5, (SELECT role_id FROM ohc.role WHERE role_name = 'doctor'), 'General Practitioner'),
    (6, (SELECT role_id FROM ohc.role WHERE role_name = 'doctor'), 'Dermatologist'),
    
    -- Nurses
    (7, (SELECT role_id FROM ohc.role WHERE role_name = 'nurse'), 'ICU Nurse'),
    (8, (SELECT role_id FROM ohc.role WHERE role_name = 'nurse'), 'ER Nurse'),
    (9, (SELECT role_id FROM ohc.role WHERE role_name = 'nurse'), 'Pediatric Nurse'),
    
    -- Receptionists
    (10, (SELECT role_id FROM ohc.role WHERE role_name = 'receptionist'), 'Front Desk'),
    (11, (SELECT role_id FROM ohc.role WHERE role_name = 'receptionist'), 'Appointments Coordinator'),
    
    -- Admin
    (12, (SELECT role_id FROM ohc.role WHERE role_name = 'admin'), 'System Administrator'),
    
    -- Patients
    (13, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (14, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (15, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (16, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (17, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (18, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (19, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (20, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (21, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (22, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (23, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (24, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    (25, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), NULL),
    
    -- Some doctors are also patients (they visit other doctors)
    (1, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), 'Staff patient'),
    (2, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), 'Staff patient'),
    (6, (SELECT role_id FROM ohc.role WHERE role_name = 'patient'), 'Staff patient');
GO

-- ============================================================================
-- SECTION 3: DOCTOR DETAILS
-- ============================================================================

INSERT INTO ohc.doctor_details (person_id, specialization, license_number, license_expiry, years_of_experience, qualification, bio) VALUES
    (1, N'Cardiology', 'MD-2005-0012', '2027-03-15', 20, 'MD, FACC, PhD', N'Dr. Williams is a board-certified cardiologist with over 20 years of experience in treating complex cardiovascular conditions. He specializes in interventional cardiology and heart failure management.'),
    (2, N'Neurology', 'MD-2008-0045', '2026-07-22', 17, 'MD, PhD Neuroscience', N'Dr. Johnson is an expert in neurological disorders, with particular focus on stroke prevention and treatment. She has published extensively in peer-reviewed journals.'),
    (3, N'Orthopedic Surgery', 'MD-2002-0089', '2027-11-08', 23, 'MD, FAAOS', N'Dr. Chen is a renowned orthopedic surgeon specializing in joint replacement and sports medicine. He has performed over 5,000 successful surgeries.'),
    (4, N'Pediatrics', 'MD-2012-0156', '2028-04-30', 13, 'MD, FAAP', N'Dr. Davis is a compassionate pediatrician dedicated to providing comprehensive care for children from birth through adolescence.'),
    (5, N'General Practice', 'MD-1998-0023', '2026-09-12', 27, 'MD, MPH', N'Dr. Anderson is a highly experienced family physician providing preventive care and treatment for patients of all ages.'),
    (6, N'Dermatology', 'MD-2006-0078', '2027-12-05', 19, 'MD, FAAD', N'Dr. Thompson specializes in medical and cosmetic dermatology, treating conditions ranging from acne to skin cancer.');
GO

-- ============================================================================
-- SECTION 4: PATIENT DETAILS
-- ============================================================================

INSERT INTO ohc.patient_details (person_id, blood_type, allergies, medical_conditions, emergency_contact, emergency_phone, insurance_provider, insurance_number, notes) VALUES
    -- Staff who are also patients
    (1, 'A+', NULL, N'Mild hypertension', N'Mary Williams', '+1-555-0101', 'BlueCross BlueShield', 'BCBS-2024-0001', N'Staff member - priority scheduling'),
    (2, 'O+', N'Shellfish', NULL, N'John Johnson', '+1-555-0102', 'Aetna', 'AET-2024-0002', N'Staff member'),
    (6, 'B+', NULL, N'Seasonal allergies', N'Mark Thompson', '+1-555-0106', 'United Healthcare', 'UHC-2024-0006', N'Staff member'),
    
    -- Regular patients
    (13, 'A-', N'Penicillin, Sulfa drugs', N'Asthma, Anxiety', N'Tom Jackson', '+1-555-0113', 'Cigna', 'CIG-2024-0013', N'Requires pre-medication before dental procedures'),
    (14, 'O-', N'Aspirin', N'Type 2 Diabetes, Hypertension, High Cholesterol', N'Susan White', '+1-555-0114', 'Medicare', 'MCR-2024-0014', N'Elderly patient - needs assistance'),
    (15, 'AB+', NULL, N'Migraine', N'Peter Harris', '+1-555-0115', 'BlueCross BlueShield', 'BCBS-2024-0015', NULL),
    (16, 'B-', N'Latex, Iodine', N'Chronic back pain', N'Laura Martin', '+1-555-0116', 'Aetna', 'AET-2024-0016', N'History of lumbar surgery'),
    (17, 'A+', NULL, NULL, N'David Robinson', '+1-555-0117', 'United Healthcare', 'UHC-2024-0017', N'Generally healthy young adult'),
    (18, 'O+', N'Peanuts, Tree nuts', N'Coronary artery disease, Previous MI', N'Barbara Clark', '+1-555-0118', 'Medicare', 'MCR-2024-0018', N'Carries EpiPen'),
    (19, 'AB-', NULL, N'Hypothyroidism', N'Steven Lewis', '+1-555-0119', 'Cigna', 'CIG-2024-0019', NULL),
    (20, 'B+', N'Codeine', N'GERD', N'Nancy Walker', '+1-555-0120', 'Humana', 'HUM-2024-0020', NULL),
    (21, 'A+', NULL, NULL, N'Robert Hall Sr.', '+1-555-0121', 'BlueCross BlueShield', 'BCBS-2024-0021', N'Young adult - first time patient'),
    (22, 'O+', N'Bee stings', N'Atrial fibrillation, COPD', N'Margaret Allen', '+1-555-0122', 'Medicare', 'MCR-2024-0022', N'Elderly patient - multiple comorbidities'),
    (23, 'A-', NULL, N'Acne, Eczema', N'James Young', '+1-555-0123', 'Aetna', 'AET-2024-0023', NULL),
    (24, 'B+', N'NSAIDs', N'Osteoarthritis, Gout', N'Patricia King', '+1-555-0124', 'United Healthcare', 'UHC-2024-0024', NULL),
    (25, 'AB+', NULL, N'Rheumatoid arthritis', N'George Wright', '+1-555-0125', 'Cigna', 'CIG-2024-0025', N'On immunosuppressive therapy');
GO

-- ============================================================================
-- SECTION 5: CONTACT INFORMATION
-- ============================================================================

INSERT INTO ohc.contact (person_id, contact_type, contact_value, context, is_primary, is_verified) VALUES
    -- Doctors - professional contacts
    (1, 'email', 'r.williams@cityhospital.com', 'professional', 1, 1),
    (1, 'phone', '+1-555-1001', 'professional', 1, 1),
    (1, 'email', 'robert.williams@gmail.com', 'personal', 0, 1),
    (2, 'email', 's.johnson@cityhospital.com', 'professional', 1, 1),
    (2, 'phone', '+1-555-1002', 'professional', 1, 1),
    (3, 'email', 'm.chen@cityhospital.com', 'professional', 1, 1),
    (3, 'phone', '+1-555-1003', 'professional', 1, 1),
    (4, 'email', 'e.davis@pediatriccare.com', 'professional', 1, 1),
    (4, 'phone', '+1-555-1004', 'professional', 1, 1),
    (5, 'email', 'j.anderson@familymed.com', 'professional', 1, 1),
    (5, 'phone', '+1-555-1005', 'professional', 1, 1),
    (6, 'email', 'l.thompson@skinhealth.com', 'professional', 1, 1),
    (6, 'phone', '+1-555-1006', 'professional', 1, 1),
    
    -- Nurses
    (7, 'email', 'j.martinez@cityhospital.com', 'professional', 1, 1),
    (7, 'phone', '+1-555-1007', 'professional', 1, 1),
    (8, 'email', 'd.garcia@cityhospital.com', 'professional', 1, 1),
    (8, 'phone', '+1-555-1008', 'professional', 1, 1),
    (9, 'email', 'a.wilson@pediatriccare.com', 'professional', 1, 1),
    (9, 'phone', '+1-555-1009', 'professional', 1, 1),
    
    -- Receptionists
    (10, 'email', 'm.brown@cityhospital.com', 'professional', 1, 1),
    (10, 'phone', '+1-555-1010', 'professional', 1, 1),
    (11, 'email', 'k.taylor@cityhospital.com', 'professional', 1, 1),
    (11, 'phone', '+1-555-1011', 'professional', 1, 1),
    
    -- Admin
    (12, 'email', 'c.moore@cityhospital.com', 'professional', 1, 1),
    (12, 'phone', '+1-555-1012', 'professional', 1, 1),
    
    -- Patients - personal contacts
    (13, 'email', 'emma.jackson@email.com', 'personal', 1, 1),
    (13, 'phone', '+1-555-2013', 'personal', 1, 1),
    (14, 'email', 'william.white@email.com', 'personal', 1, 1),
    (14, 'phone', '+1-555-2014', 'personal', 1, 1),
    (14, 'phone', '+1-555-2014-2', 'emergency', 0, 1),
    (15, 'email', 'olivia.harris@email.com', 'personal', 1, 1),
    (15, 'phone', '+1-555-2015', 'personal', 1, 1),
    (16, 'email', 'alex.martin@email.com', 'personal', 1, 1),
    (16, 'phone', '+1-555-2016', 'personal', 1, 1),
    (17, 'email', 'sophia.robinson@email.com', 'personal', 1, 1),
    (17, 'phone', '+1-555-2017', 'personal', 1, 1),
    (18, 'email', 'daniel.clark@email.com', 'personal', 1, 1),
    (18, 'phone', '+1-555-2018', 'personal', 1, 1),
    (19, 'email', 'isabella.lewis@email.com', 'personal', 1, 1),
    (19, 'phone', '+1-555-2019', 'personal', 1, 1),
    (20, 'email', 'matthew.walker@email.com', 'personal', 1, 1),
    (20, 'phone', '+1-555-2020', 'personal', 1, 1),
    (21, 'email', 'ava.hall@email.com', 'personal', 1, 1),
    (21, 'phone', '+1-555-2021', 'personal', 1, 1),
    (22, 'email', 'ethan.allen@email.com', 'personal', 1, 1),
    (22, 'phone', '+1-555-2022', 'personal', 1, 1),
    (23, 'email', 'mia.young@email.com', 'personal', 1, 1),
    (23, 'phone', '+1-555-2023', 'personal', 1, 1),
    (24, 'email', 'ben.king@email.com', 'personal', 1, 1),
    (24, 'phone', '+1-555-2024', 'personal', 1, 1),
    (25, 'email', 'charlotte.wright@email.com', 'personal', 1, 1),
    (25, 'phone', '+1-555-2025', 'personal', 1, 1);
GO

-- ============================================================================
-- SECTION 6: ADDRESSES
-- ============================================================================

INSERT INTO ohc.address (person_id, address_type, address_line1, address_line2, city, region, postal_code, country, is_primary) VALUES
    -- Doctors
    (1, 'work', N'100 Medical Center Drive', N'Suite 500', N'Springfield', N'Illinois', '62701', N'USA', 1),
    (1, 'home', N'245 Oak Lane', NULL, N'Springfield', N'Illinois', '62702', N'USA', 0),
    (2, 'work', N'100 Medical Center Drive', N'Suite 310', N'Springfield', N'Illinois', '62701', N'USA', 1),
    (3, 'work', N'100 Medical Center Drive', N'Suite 200', N'Springfield', N'Illinois', '62701', N'USA', 1),
    (4, 'work', N'50 Children''s Way', NULL, N'Springfield', N'Illinois', '62703', N'USA', 1),
    (5, 'work', N'200 Family Care Boulevard', NULL, N'Springfield', N'Illinois', '62704', N'USA', 1),
    (6, 'work', N'75 Dermatology Center', N'Floor 2', N'Springfield', N'Illinois', '62705', N'USA', 1),
    
    -- Patients
    (13, 'home', N'123 Maple Street', N'Apt 4B', N'Springfield', N'Illinois', '62706', N'USA', 1),
    (14, 'home', N'456 Elm Avenue', NULL, N'Springfield', N'Illinois', '62707', N'USA', 1),
    (15, 'home', N'789 Pine Road', N'Unit 12', N'Springfield', N'Illinois', '62708', N'USA', 1),
    (16, 'home', N'321 Cedar Lane', NULL, N'Springfield', N'Illinois', '62709', N'USA', 1),
    (17, 'home', N'654 Birch Street', N'Apt 7A', N'Springfield', N'Illinois', '62710', N'USA', 1),
    (18, 'home', N'987 Walnut Drive', NULL, N'Springfield', N'Illinois', '62711', N'USA', 1),
    (19, 'home', N'147 Spruce Court', NULL, N'Springfield', N'Illinois', '62712', N'USA', 1),
    (20, 'home', N'258 Ash Boulevard', N'Suite 3', N'Springfield', N'Illinois', '62713', N'USA', 1),
    (21, 'home', N'369 Willow Way', NULL, N'Springfield', N'Illinois', '62714', N'USA', 1),
    (22, 'home', N'741 Hickory Hills', NULL, N'Springfield', N'Illinois', '62715', N'USA', 1),
    (23, 'home', N'852 Magnolia Lane', N'Apt 2C', N'Springfield', N'Illinois', '62716', N'USA', 1),
    (24, 'home', N'963 Cypress Circle', NULL, N'Springfield', N'Illinois', '62717', N'USA', 1),
    (25, 'home', N'159 Redwood Road', NULL, N'Springfield', N'Illinois', '62718', N'USA', 1);
GO

-- ============================================================================
-- SECTION 7: CLINICS
-- ============================================================================

INSERT INTO ohc.clinic (clinic_name, clinic_type, city, address, phone, email, website, operating_hours) VALUES
    (N'Springfield General Hospital', 'hospital', N'Springfield', N'100 Medical Center Drive', '+1-555-3000', 'info@springfieldgeneral.com', 'www.springfieldgeneral.com', 'Open 24/7'),
    (N'Downtown Family Medicine', 'private_practice', N'Springfield', N'200 Family Care Boulevard', '+1-555-3001', 'info@downtownfamily.com', 'www.downtownfamily.com', 'Mon-Fri: 8:00-18:00, Sat: 9:00-14:00'),
    (N'Pediatric Care Center', 'private_practice', N'Springfield', N'50 Children''s Way', '+1-555-3002', 'info@pedcare.com', 'www.pedcare.com', 'Mon-Fri: 8:00-17:00, Sat: 9:00-12:00'),
    (N'Springfield Skin Health', 'private_practice', N'Springfield', N'75 Dermatology Center', '+1-555-3003', 'info@skinhealth.com', 'www.skinhealth.com', 'Mon-Fri: 9:00-17:00'),
    (N'Orthopedic & Sports Medicine', 'private_practice', N'Springfield', N'150 Athletic Way', '+1-555-3004', 'info@orthosports.com', 'www.orthosports.com', 'Mon-Fri: 7:00-19:00, Sat: 8:00-14:00'),
    (N'Urgent Care Springfield', 'urgent_care', N'Springfield', N'300 Quick Care Lane', '+1-555-3005', 'info@urgentcare.com', 'www.urgentcare.com', 'Daily: 8:00-22:00');
GO

-- ============================================================================
-- SECTION 8: DOCTOR-CLINIC SCHEDULES
-- ============================================================================
-- Note: day_of_week: 1=Monday, 7=Sunday (with SET DATEFIRST 1)

INSERT INTO ohc.doctor_clinic (doctor_id, clinic_id, day_of_week, start_time, end_time) VALUES
    -- Dr. Williams (Cardiology) - Hospital Mon-Thu, Urgent Care Fri
    (1, 1, 1, '08:00', '16:00'),  -- Monday at Hospital
    (1, 1, 2, '08:00', '16:00'),  -- Tuesday at Hospital
    (1, 1, 3, '08:00', '16:00'),  -- Wednesday at Hospital
    (1, 1, 4, '08:00', '16:00'),  -- Thursday at Hospital
    (1, 6, 5, '09:00', '15:00'),  -- Friday at Urgent Care
    
    -- Dr. Johnson (Neurology) - Hospital Mon-Fri
    (2, 1, 1, '09:00', '17:00'),
    (2, 1, 2, '09:00', '17:00'),
    (2, 1, 3, '09:00', '17:00'),
    (2, 1, 4, '09:00', '17:00'),
    (2, 1, 5, '09:00', '14:00'),
    
    -- Dr. Chen (Orthopedics) - Hospital Mon-Wed, Ortho Clinic Thu-Sat
    (3, 1, 1, '07:00', '15:00'),
    (3, 1, 2, '07:00', '15:00'),
    (3, 1, 3, '07:00', '15:00'),
    (3, 5, 4, '08:00', '18:00'),
    (3, 5, 5, '08:00', '18:00'),
    (3, 5, 6, '08:00', '14:00'),
    
    -- Dr. Davis (Pediatrics) - Pediatric Center Mon-Fri, Hospital Sat
    (4, 3, 1, '08:00', '17:00'),
    (4, 3, 2, '08:00', '17:00'),
    (4, 3, 3, '08:00', '17:00'),
    (4, 3, 4, '08:00', '17:00'),
    (4, 3, 5, '08:00', '17:00'),
    (4, 1, 6, '09:00', '13:00'),
    
    -- Dr. Anderson (General Practice) - Family Medicine Mon-Sat
    (5, 2, 1, '08:00', '18:00'),
    (5, 2, 2, '08:00', '18:00'),
    (5, 2, 3, '08:00', '18:00'),
    (5, 2, 4, '08:00', '18:00'),
    (5, 2, 5, '08:00', '18:00'),
    (5, 2, 6, '09:00', '14:00'),
    
    -- Dr. Thompson (Dermatology) - Skin Health Mon-Fri
    (6, 4, 1, '09:00', '17:00'),
    (6, 4, 2, '09:00', '17:00'),
    (6, 4, 3, '09:00', '17:00'),
    (6, 4, 4, '09:00', '17:00'),
    (6, 4, 5, '09:00', '17:00');
GO

-- ============================================================================
-- SECTION 9: MEDICINE CATALOG
-- ============================================================================

INSERT INTO ohc.medicine (medicine_name, generic_name, category, form, strength, manufacturer, requires_prescription, notes) VALUES
    -- Cardiovascular
    (N'Lisinopril', 'Lisinopril', 'antihypertensive', 'tablet', '10mg', 'Merck', 1, N'ACE inhibitor for hypertension'),
    (N'Lisinopril', 'Lisinopril', 'antihypertensive', 'tablet', '20mg', 'Merck', 1, N'ACE inhibitor for hypertension'),
    (N'Metoprolol', 'Metoprolol Tartrate', 'beta_blocker', 'tablet', '50mg', 'AstraZeneca', 1, N'Beta blocker for heart conditions'),
    (N'Atorvastatin', 'Atorvastatin Calcium', 'statin', 'tablet', '20mg', 'Pfizer', 1, N'Cholesterol management'),
    (N'Atorvastatin', 'Atorvastatin Calcium', 'statin', 'tablet', '40mg', 'Pfizer', 1, N'Cholesterol management'),
    (N'Warfarin', 'Warfarin Sodium', 'anticoagulant', 'tablet', '5mg', 'Bristol-Myers', 1, N'Blood thinner - requires INR monitoring'),
    (N'Aspirin', 'Acetylsalicylic Acid', 'antiplatelet', 'tablet', '81mg', 'Bayer', 0, N'Low-dose aspirin for heart health'),
    
    -- Pain Management
    (N'Ibuprofen', 'Ibuprofen', 'nsaid', 'tablet', '400mg', 'Advil', 0, N'Pain and inflammation relief'),
    (N'Ibuprofen', 'Ibuprofen', 'nsaid', 'tablet', '800mg', 'Advil', 1, N'Prescription strength'),
    (N'Acetaminophen', 'Acetaminophen', 'analgesic', 'tablet', '500mg', 'Tylenol', 0, N'Pain and fever relief'),
    (N'Tramadol', 'Tramadol HCl', 'opioid', 'tablet', '50mg', 'Janssen', 1, N'Moderate to severe pain'),
    (N'Gabapentin', 'Gabapentin', 'anticonvulsant', 'capsule', '300mg', 'Pfizer', 1, N'Nerve pain and seizures'),
    
    -- Antibiotics
    (N'Amoxicillin', 'Amoxicillin', 'antibiotic', 'capsule', '500mg', 'GSK', 1, N'Broad-spectrum antibiotic'),
    (N'Azithromycin', 'Azithromycin', 'antibiotic', 'tablet', '250mg', 'Pfizer', 1, N'Z-pack antibiotic'),
    (N'Ciprofloxacin', 'Ciprofloxacin HCl', 'antibiotic', 'tablet', '500mg', 'Bayer', 1, N'Fluoroquinolone antibiotic'),
    (N'Doxycycline', 'Doxycycline Hyclate', 'antibiotic', 'capsule', '100mg', 'Mylan', 1, N'Tetracycline antibiotic'),
    
    -- Respiratory
    (N'Albuterol', 'Albuterol Sulfate', 'bronchodilator', 'inhaler', '90mcg', 'GSK', 1, N'Rescue inhaler for asthma'),
    (N'Fluticasone', 'Fluticasone Propionate', 'corticosteroid', 'inhaler', '250mcg', 'GSK', 1, N'Maintenance inhaler'),
    (N'Montelukast', 'Montelukast Sodium', 'leukotriene_inhibitor', 'tablet', '10mg', 'Merck', 1, N'Asthma and allergy prevention'),
    
    -- Gastrointestinal
    (N'Omeprazole', 'Omeprazole', 'ppi', 'capsule', '20mg', 'AstraZeneca', 0, N'Acid reflux relief'),
    (N'Omeprazole', 'Omeprazole', 'ppi', 'capsule', '40mg', 'AstraZeneca', 1, N'Prescription strength'),
    (N'Ondansetron', 'Ondansetron HCl', 'antiemetic', 'tablet', '4mg', 'GSK', 1, N'Anti-nausea medication'),
    
    -- Diabetes
    (N'Metformin', 'Metformin HCl', 'antidiabetic', 'tablet', '500mg', 'Bristol-Myers', 1, N'Type 2 diabetes first-line'),
    (N'Metformin', 'Metformin HCl', 'antidiabetic', 'tablet', '1000mg', 'Bristol-Myers', 1, N'Type 2 diabetes'),
    (N'Glipizide', 'Glipizide', 'sulfonylurea', 'tablet', '5mg', 'Pfizer', 1, N'Type 2 diabetes'),
    
    -- Mental Health
    (N'Sertraline', 'Sertraline HCl', 'ssri', 'tablet', '50mg', 'Pfizer', 1, N'Depression and anxiety'),
    (N'Escitalopram', 'Escitalopram Oxalate', 'ssri', 'tablet', '10mg', 'Allergan', 1, N'Depression and anxiety'),
    (N'Alprazolam', 'Alprazolam', 'benzodiazepine', 'tablet', '0.5mg', 'Pfizer', 1, N'Anxiety - controlled substance'),
    (N'Zolpidem', 'Zolpidem Tartrate', 'sedative', 'tablet', '10mg', 'Sanofi', 1, N'Sleep aid - controlled substance'),
    
    -- Thyroid
    (N'Levothyroxine', 'Levothyroxine Sodium', 'thyroid', 'tablet', '50mcg', 'Synthroid', 1, N'Hypothyroidism'),
    (N'Levothyroxine', 'Levothyroxine Sodium', 'thyroid', 'tablet', '100mcg', 'Synthroid', 1, N'Hypothyroidism'),
    
    -- Allergy
    (N'Loratadine', 'Loratadine', 'antihistamine', 'tablet', '10mg', 'Claritin', 0, N'Non-drowsy allergy relief'),
    (N'Cetirizine', 'Cetirizine HCl', 'antihistamine', 'tablet', '10mg', 'Zyrtec', 0, N'Allergy relief'),
    (N'Prednisone', 'Prednisone', 'corticosteroid', 'tablet', '10mg', 'Pfizer', 1, N'Inflammation and allergies'),
    (N'Prednisone', 'Prednisone', 'corticosteroid', 'tablet', '20mg', 'Pfizer', 1, N'Inflammation and allergies'),
    
    -- Dermatology
    (N'Hydrocortisone', 'Hydrocortisone', 'corticosteroid', 'cream', '1%', 'Various', 0, N'Skin inflammation'),
    (N'Tretinoin', 'Tretinoin', 'retinoid', 'cream', '0.025%', 'Valeant', 1, N'Acne treatment'),
    (N'Ketoconazole', 'Ketoconazole', 'antifungal', 'cream', '2%', 'Janssen', 1, N'Fungal skin infections'),
    
    -- Musculoskeletal
    (N'Cyclobenzaprine', 'Cyclobenzaprine HCl', 'muscle_relaxant', 'tablet', '10mg', 'Mylan', 1, N'Muscle spasms'),
    (N'Allopurinol', 'Allopurinol', 'antigout', 'tablet', '100mg', 'Mylan', 1, N'Gout prevention'),
    (N'Colchicine', 'Colchicine', 'antigout', 'tablet', '0.6mg', 'Takeda', 1, N'Acute gout attacks');
GO

-- ============================================================================
-- SECTION 10: USER ACCOUNTS
-- ============================================================================

INSERT INTO ohc.user_account (person_id, username, password_hash, email) VALUES
    -- Doctors
    (1, 'dr.williams', 'HASH_$2b$12$LQv3c1yqBw...placeholder1', 'r.williams@cityhospital.com'),
    (2, 'dr.johnson', 'HASH_$2b$12$LQv3c1yqBw...placeholder2', 's.johnson@cityhospital.com'),
    (3, 'dr.chen', 'HASH_$2b$12$LQv3c1yqBw...placeholder3', 'm.chen@cityhospital.com'),
    (4, 'dr.davis', 'HASH_$2b$12$LQv3c1yqBw...placeholder4', 'e.davis@pediatriccare.com'),
    (5, 'dr.anderson', 'HASH_$2b$12$LQv3c1yqBw...placeholder5', 'j.anderson@familymed.com'),
    (6, 'dr.thompson', 'HASH_$2b$12$LQv3c1yqBw...placeholder6', 'l.thompson@skinhealth.com'),
    
    -- Nurses
    (7, 'nurse.martinez', 'HASH_$2b$12$LQv3c1yqBw...placeholder7', 'j.martinez@cityhospital.com'),
    (8, 'nurse.garcia', 'HASH_$2b$12$LQv3c1yqBw...placeholder8', 'd.garcia@cityhospital.com'),
    (9, 'nurse.wilson', 'HASH_$2b$12$LQv3c1yqBw...placeholder9', 'a.wilson@pediatriccare.com'),
    
    -- Receptionists
    (10, 'rec.brown', 'HASH_$2b$12$LQv3c1yqBw...placeholder10', 'm.brown@cityhospital.com'),
    (11, 'rec.taylor', 'HASH_$2b$12$LQv3c1yqBw...placeholder11', 'k.taylor@cityhospital.com'),
    
    -- Admin
    (12, 'admin.moore', 'HASH_$2b$12$LQv3c1yqBw...placeholder12', 'c.moore@cityhospital.com'),
    
    -- Patients
    (13, 'emma.jackson', 'HASH_$2b$12$LQv3c1yqBw...placeholder13', 'emma.jackson@email.com'),
    (14, 'william.white', 'HASH_$2b$12$LQv3c1yqBw...placeholder14', 'william.white@email.com'),
    (15, 'olivia.harris', 'HASH_$2b$12$LQv3c1yqBw...placeholder15', 'olivia.harris@email.com'),
    (16, 'alex.martin', 'HASH_$2b$12$LQv3c1yqBw...placeholder16', 'alex.martin@email.com'),
    (17, 'sophia.robinson', 'HASH_$2b$12$LQv3c1yqBw...placeholder17', 'sophia.robinson@email.com'),
    (18, 'daniel.clark', 'HASH_$2b$12$LQv3c1yqBw...placeholder18', 'daniel.clark@email.com'),
    (19, 'isabella.lewis', 'HASH_$2b$12$LQv3c1yqBw...placeholder19', 'isabella.lewis@email.com'),
    (20, 'matthew.walker', 'HASH_$2b$12$LQv3c1yqBw...placeholder20', 'matthew.walker@email.com'),
    (21, 'ava.hall', 'HASH_$2b$12$LQv3c1yqBw...placeholder21', 'ava.hall@email.com'),
    (22, 'ethan.allen', 'HASH_$2b$12$LQv3c1yqBw...placeholder22', 'ethan.allen@email.com'),
    (23, 'mia.young', 'HASH_$2b$12$LQv3c1yqBw...placeholder23', 'mia.young@email.com'),
    (24, 'ben.king', 'HASH_$2b$12$LQv3c1yqBw...placeholder24', 'ben.king@email.com'),
    (25, 'charlotte.wright', 'HASH_$2b$12$LQv3c1yqBw...placeholder25', 'charlotte.wright@email.com');
GO

-- ============================================================================
-- SECTION 11: APPOINTMENTS (FIXED)
-- ============================================================================
-- Using proper DATETIME2 arithmetic with DATEADD

DECLARE @today DATE = CAST(GETDATE() AS DATE);
DECLARE @monday DATE = DATEADD(DAY, 1 - DATEPART(WEEKDAY, @today), @today);
SET DATEFIRST 1;

INSERT INTO ohc.appointment (patient_id, doctor_id, clinic_id, appointment_start, appointment_end, status, reason, notes) VALUES
    -- Past appointments (completed) - Last week
    (13, 5, 2, 
        DATEADD(HOUR, 9, CAST(DATEADD(DAY, -7, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 9, CAST(DATEADD(DAY, -7, @monday) AS DATETIME2))), 
        'completed', N'Annual physical examination', N'Patient in good health'),
    
    (14, 1, 1, 
        DATEADD(HOUR, 10, CAST(DATEADD(DAY, -7, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 45, DATEADD(HOUR, 10, CAST(DATEADD(DAY, -7, @monday) AS DATETIME2))), 
        'completed', N'Follow-up for hypertension', N'Blood pressure improved'),
    
    (15, 2, 1, 
        DATEADD(HOUR, 11, CAST(DATEADD(DAY, -6, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 11, CAST(DATEADD(DAY, -6, @monday) AS DATETIME2))), 
        'completed', N'Migraine consultation', N'New treatment plan discussed'),
    
    (16, 3, 1, 
        DATEADD(HOUR, 8, CAST(DATEADD(DAY, -6, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 45, DATEADD(HOUR, 8, CAST(DATEADD(DAY, -6, @monday) AS DATETIME2))), 
        'completed', N'Back pain evaluation', N'Recommended physical therapy'),
    
    (18, 1, 1, 
        DATEADD(HOUR, 9, CAST(DATEADD(DAY, -5, @monday) AS DATETIME2)), 
        DATEADD(HOUR, 10, CAST(DATEADD(DAY, -5, @monday) AS DATETIME2)), 
        'completed', N'Cardiac follow-up post MI', N'Stable condition'),
    
    (22, 1, 1, 
        DATEADD(HOUR, 14, CAST(DATEADD(DAY, -5, @monday) AS DATETIME2)), 
        DATEADD(HOUR, 15, CAST(DATEADD(DAY, -5, @monday) AS DATETIME2)), 
        'completed', N'Atrial fibrillation management', N'Adjusted medication'),
    
    (17, 5, 2, 
        DATEADD(HOUR, 10, CAST(DATEADD(DAY, -4, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 10, CAST(DATEADD(DAY, -4, @monday) AS DATETIME2))), 
        'completed', N'Wellness check', N'All clear'),
    
    (19, 5, 2, 
        DATEADD(HOUR, 14, CAST(DATEADD(DAY, -4, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 14, CAST(DATEADD(DAY, -4, @monday) AS DATETIME2))), 
        'completed', N'Thyroid medication review', N'Dosage maintained'),
    
    (23, 6, 4, 
        DATEADD(HOUR, 10, CAST(DATEADD(DAY, -3, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 10, CAST(DATEADD(DAY, -3, @monday) AS DATETIME2))), 
        'completed', N'Acne treatment follow-up', N'Improvement noted'),
    
    (20, 5, 2, 
        DATEADD(HOUR, 11, CAST(DATEADD(DAY, -2, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 11, CAST(DATEADD(DAY, -2, @monday) AS DATETIME2))), 
        'completed', N'GERD symptoms', N'Prescribed medication'),
    
    -- Cancelled appointments
    (21, 4, 3, 
        DATEADD(HOUR, 9, CAST(DATEADD(DAY, -3, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 9, CAST(DATEADD(DAY, -3, @monday) AS DATETIME2))), 
        'cancelled', N'New patient visit', N'Patient cancelled - rescheduled'),
    
    (24, 3, 5, 
        DATEADD(HOUR, 10, CAST(DATEADD(DAY, -1, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 45, DATEADD(HOUR, 10, CAST(DATEADD(DAY, -1, @monday) AS DATETIME2))), 
        'cancelled', N'Joint pain consultation', N'Weather related cancellation'),
    
    -- No-show
    (25, 6, 4, 
        DATEADD(HOUR, 14, CAST(DATEADD(DAY, -4, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 14, CAST(DATEADD(DAY, -4, @monday) AS DATETIME2))), 
        'no_show', N'Skin rash evaluation', N'Patient did not appear'),
    
    -- This week - scheduled/confirmed
    (13, 1, 1, 
        DATEADD(HOUR, 9, CAST(@monday AS DATETIME2)), 
        DATEADD(MINUTE, 45, DATEADD(HOUR, 9, CAST(@monday AS DATETIME2))), 
        'confirmed', N'Heart palpitation concerns', NULL),
    
    (14, 5, 2, 
        DATEADD(HOUR, 10, CAST(@monday AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 10, CAST(@monday AS DATETIME2))), 
        'scheduled', N'Diabetes management', NULL),
    
    (15, 2, 1, 
        DATEADD(HOUR, 10, CAST(DATEADD(DAY, 1, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 10, CAST(DATEADD(DAY, 1, @monday) AS DATETIME2))), 
        'confirmed', N'Migraine follow-up', NULL),
    
    (16, 3, 1, 
        DATEADD(HOUR, 8, CAST(DATEADD(DAY, 1, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 45, DATEADD(HOUR, 8, CAST(DATEADD(DAY, 1, @monday) AS DATETIME2))), 
        'scheduled', N'Physical therapy progress', NULL),
    
    (18, 1, 1, 
        DATEADD(HOUR, 11, CAST(DATEADD(DAY, 2, @monday) AS DATETIME2)), 
        DATEADD(HOUR, 12, CAST(DATEADD(DAY, 2, @monday) AS DATETIME2)), 
        'confirmed', N'Stress test results', NULL),
    
    (21, 4, 3, 
        DATEADD(HOUR, 9, CAST(DATEADD(DAY, 2, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 9, CAST(DATEADD(DAY, 2, @monday) AS DATETIME2))), 
        'scheduled', N'New patient visit', N'Rescheduled from last week'),
    
    (22, 2, 1, 
        DATEADD(HOUR, 14, CAST(DATEADD(DAY, 3, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 45, DATEADD(HOUR, 14, CAST(DATEADD(DAY, 3, @monday) AS DATETIME2))), 
        'scheduled', N'Cognitive assessment', NULL),
    
    (24, 3, 5, 
        DATEADD(HOUR, 9, CAST(DATEADD(DAY, 3, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 45, DATEADD(HOUR, 9, CAST(DATEADD(DAY, 3, @monday) AS DATETIME2))), 
        'confirmed', N'Gout treatment review', NULL),
    
    (23, 6, 4, 
        DATEADD(HOUR, 11, CAST(DATEADD(DAY, 4, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 11, CAST(DATEADD(DAY, 4, @monday) AS DATETIME2))), 
        'scheduled', N'Eczema follow-up', NULL),
    
    (25, 5, 2, 
        DATEADD(HOUR, 15, CAST(DATEADD(DAY, 4, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 45, DATEADD(HOUR, 15, CAST(DATEADD(DAY, 4, @monday) AS DATETIME2))), 
        'scheduled', N'RA medication review', NULL),
    
    -- Next week appointments
    (17, 4, 3, 
        DATEADD(HOUR, 10, CAST(DATEADD(DAY, 7, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 10, CAST(DATEADD(DAY, 7, @monday) AS DATETIME2))), 
        'scheduled', N'Wellness check', NULL),
    
    (19, 1, 1, 
        DATEADD(HOUR, 13, CAST(DATEADD(DAY, 8, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 45, DATEADD(HOUR, 13, CAST(DATEADD(DAY, 8, @monday) AS DATETIME2))), 
        'scheduled', N'Thyroid function review', NULL),
    
    (20, 5, 2, 
        DATEADD(HOUR, 9, CAST(DATEADD(DAY, 9, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 9, CAST(DATEADD(DAY, 9, @monday) AS DATETIME2))), 
        'scheduled', N'GERD follow-up', NULL),
    
    -- Doctor as patient appointments
    (1, 5, 2, 
        DATEADD(HOUR, 17, CAST(DATEADD(DAY, 10, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 17, CAST(DATEADD(DAY, 10, @monday) AS DATETIME2))), 
        'scheduled', N'Annual physical', N'Staff appointment'),
    
    (2, 6, 4, 
        DATEADD(HOUR, 16, CAST(DATEADD(DAY, 11, @monday) AS DATETIME2)), 
        DATEADD(MINUTE, 30, DATEADD(HOUR, 16, CAST(DATEADD(DAY, 11, @monday) AS DATETIME2))), 
        'scheduled', N'Skin check', N'Staff appointment');
GO

-- ============================================================================
-- SECTION 12: MEDICAL RECORDS (FIXED - references correct appointment IDs)
-- ============================================================================

INSERT INTO ohc.medical_record (patient_id, doctor_id, appointment_id, diagnosis, diagnosis_code, symptoms, examination_notes, treatment_plan, follow_up_required, follow_up_date) VALUES
    (13, 5, 1, N'Routine health examination - No significant findings', 'Z00.00', N'No complaints, routine checkup', N'Vital signs normal. Heart and lungs clear. Abdomen soft, non-tender. Neurological exam normal. Skin clear.', N'Continue current lifestyle. Maintain balanced diet and regular exercise. Return in 12 months for next annual exam.', 0, NULL),
    (14, 1, 2, N'Essential hypertension, controlled', 'I10', N'Occasional headaches, mild fatigue', N'BP 128/82 (improved from 145/92). Heart sounds regular, no murmurs. No peripheral edema. Fundoscopic exam normal.', N'Continue Lisinopril 20mg daily. Low sodium diet. Daily walks 30 minutes. Recheck BP in 3 months.', 1, DATEADD(MONTH, 3, GETDATE())),
    (15, 2, 3, N'Migraine without aura', 'G43.009', N'Severe unilateral headache, photophobia, nausea, 3-4 episodes per month', N'Neurological exam normal. No focal deficits. Fundoscopic exam normal. Neck supple. DTRs symmetric.', N'Start Sumatriptan 50mg for acute attacks. Consider preventive therapy if frequency increases. Avoid known triggers. Sleep hygiene counseling provided.', 1, DATEADD(MONTH, 1, GETDATE())),
    (16, 3, 4, N'Chronic low back pain, lumbar region', 'M54.5', N'Persistent lower back pain, worse with prolonged sitting, radiating to left leg', N'Limited lumbar flexion. Positive straight leg raise left at 45 degrees. Muscle spasm palpable L4-L5. Motor strength 5/5 bilateral. Sensory intact.', N'Physical therapy 2x weekly for 6 weeks. Cyclobenzaprine 10mg at bedtime PRN. Ice/heat as needed. Ergonomic workstation assessment recommended. Follow-up in 6 weeks.', 1, DATEADD(WEEK, 6, GETDATE())),
    (18, 1, 5, N'Personal history of myocardial infarction, stable angina', 'Z86.79', N'Occasional mild chest discomfort with exertion, no rest pain', N'BP 124/78. HR 68 regular. S1S2 normal, no murmurs or gallops. Lungs clear. No peripheral edema. ECG shows old inferior MI changes, no acute changes.', N'Continue current medications: Aspirin 81mg, Metoprolol 50mg BID, Atorvastatin 40mg, Lisinopril 10mg. Cardiac rehab completion congratulated. Annual stress test recommended.', 1, DATEADD(MONTH, 6, GETDATE())),
    (22, 1, 6, N'Atrial fibrillation, chronic', 'I48.91', N'Occasional palpitations, mild dyspnea on exertion', N'Irregularly irregular pulse, rate 78. BP 132/84. Lungs clear. No edema. INR 2.4 (therapeutic range).', N'Continue Warfarin, target INR 2.0-3.0. Metoprolol 50mg BID for rate control. Low sodium diet. INR check every 2 weeks. Discuss ablation options at next visit.', 1, DATEADD(MONTH, 2, GETDATE())),
    (17, 5, 7, N'Routine health examination - Healthy young adult', 'Z00.00', N'No complaints', N'Healthy appearing young woman. Vital signs normal. All systems examination unremarkable. BMI 22.3.', N'Continue healthy lifestyle. Age-appropriate vaccinations up to date. Return as needed or for annual exam.', 0, NULL),
    (19, 5, 8, N'Hypothyroidism, well-controlled', 'E03.9', N'No symptoms, medication refill needed', N'No goiter palpable. Heart rate 72, regular. Skin warm, dry. Energy level reported as good. TSH 2.1 (normal range).', N'Continue Levothyroxine 100mcg daily. Annual TSH monitoring. No dose adjustment needed. Recheck labs in 12 months.', 0, NULL),
    (23, 6, 9, N'Acne vulgaris, moderate', 'L70.0', N'Facial acne, some improvement since last visit', N'Moderate inflammatory and comedonal acne on face. Fewer active lesions compared to prior visit. Some post-inflammatory hyperpigmentation. No scarring.', N'Continue Tretinoin cream 0.025% nightly. Add Benzoyl peroxide wash morning. Sun protection essential. Follow-up in 8 weeks to assess progress.', 1, DATEADD(WEEK, 8, GETDATE())),
    (20, 5, 10, N'Gastroesophageal reflux disease', 'K21.0', N'Heartburn after meals, regurgitation, worse at night', N'Abdomen soft, non-tender. No masses. Mild epigastric tenderness. No alarm symptoms (dysphagia, weight loss, bleeding).', N'Start Omeprazole 20mg before breakfast. Elevate head of bed. Avoid eating 3 hours before bed. Weight loss counseling. Avoid trigger foods. Return in 4 weeks.', 1, DATEADD(WEEK, 4, GETDATE()));
GO

-- ============================================================================
-- SECTION 13: VITAL SIGNS (uses record_id 1-10)
-- ============================================================================

INSERT INTO ohc.vital_signs (record_id, blood_pressure_sys, blood_pressure_dia, heart_rate, temperature, respiratory_rate, oxygen_saturation, weight_kg, height_cm, notes) VALUES
    (1, 118, 76, 72, 36.8, 14, 99, 62.5, 165.0, N'Normal vital signs'),
    (2, 128, 82, 78, 36.6, 16, 98, 89.3, 175.5, N'BP improved from last visit'),
    (3, 122, 78, 68, 36.7, 14, 99, 58.2, 163.0, N'Within normal limits'),
    (4, 130, 85, 82, 36.9, 16, 97, 92.1, 180.0, N'Slightly elevated BP - pain related'),
    (5, 124, 78, 68, 36.5, 14, 98, 81.6, 177.0, N'Stable cardiac parameters'),
    (6, 132, 84, 78, 36.7, 18, 96, 78.4, 172.0, N'Rate controlled AFib'),
    (7, 110, 70, 62, 36.6, 12, 99, 55.8, 160.0, N'Excellent vitals'),
    (8, 116, 74, 70, 36.8, 14, 99, 64.2, 167.0, N'Stable on thyroid medication'),
    (9, 112, 72, 68, 36.7, 14, 99, 52.3, 162.0, N'Normal for age'),
    (10, 126, 80, 76, 36.8, 16, 98, 84.5, 178.0, N'Mild elevation - anxiety about symptoms');
GO

-- ============================================================================
-- SECTION 14: PRESCRIPTIONS (uses record_id 1-10)
-- ============================================================================

DECLARE @lisinopril20 INT = (SELECT medicine_id FROM ohc.medicine WHERE medicine_name = 'Lisinopril' AND strength = '20mg');
DECLARE @lisinopril10 INT = (SELECT medicine_id FROM ohc.medicine WHERE medicine_name = 'Lisinopril' AND strength = '10mg');
DECLARE @metoprolol INT = (SELECT medicine_id FROM ohc.medicine WHERE medicine_name = 'Metoprolol' AND strength = '50mg');
DECLARE @atorvastatin40 INT = (SELECT medicine_id FROM ohc.medicine WHERE medicine_name = 'Atorvastatin' AND strength = '40mg');
DECLARE @aspirin81 INT = (SELECT medicine_id FROM ohc.medicine WHERE medicine_name = 'Aspirin' AND strength = '81mg');
DECLARE @cyclobenzaprine INT = (SELECT medicine_id FROM ohc.medicine WHERE medicine_name = 'Cyclobenzaprine');
DECLARE @warfarin INT = (SELECT medicine_id FROM ohc.medicine WHERE medicine_name = 'Warfarin');
DECLARE @levothyroxine100 INT = (SELECT medicine_id FROM ohc.medicine WHERE medicine_name = 'Levothyroxine' AND strength = '100mcg');
DECLARE @tretinoin INT = (SELECT medicine_id FROM ohc.medicine WHERE medicine_name = 'Tretinoin');
DECLARE @omeprazole20 INT = (SELECT medicine_id FROM ohc.medicine WHERE medicine_name = 'Omeprazole' AND strength = '20mg');

INSERT INTO ohc.prescription (record_id, medicine_id, medicine_name, dosage, frequency, duration_days, quantity, instructions, refills_allowed, refills_used) VALUES
    (2, @lisinopril20, N'Lisinopril 20mg', N'1 tablet', N'Once daily in the morning', 90, 90, N'Take with or without food. Monitor blood pressure regularly.', 3, 0),
    (3, NULL, N'Sumatriptan 50mg', N'1 tablet', N'At onset of migraine, may repeat after 2 hours', 30, 9, N'Do not exceed 2 tablets in 24 hours. Rest in dark room after taking.', 2, 0),
    (4, @cyclobenzaprine, N'Cyclobenzaprine 10mg', N'1 tablet', N'At bedtime as needed', 30, 30, N'May cause drowsiness. Do not drive after taking. Avoid alcohol.', 1, 0),
    (5, @aspirin81, N'Aspirin 81mg', N'1 tablet', N'Once daily', 90, 90, N'Take with food to prevent stomach upset.', 3, 1),
    (5, @metoprolol, N'Metoprolol 50mg', N'1 tablet', N'Twice daily', 90, 180, N'Do not stop abruptly. Take with food.', 3, 1),
    (5, @atorvastatin40, N'Atorvastatin 40mg', N'1 tablet', N'Once daily at bedtime', 90, 90, N'Report any unexplained muscle pain.', 3, 1),
    (5, @lisinopril10, N'Lisinopril 10mg', N'1 tablet', N'Once daily', 90, 90, N'Monitor for dry cough or swelling.', 3, 1),
    (6, @warfarin, N'Warfarin 5mg', N'1 tablet', N'Once daily', 30, 30, N'Maintain consistent vitamin K intake. Regular INR monitoring required.', 0, 0),
    (6, @metoprolol, N'Metoprolol 50mg', N'1 tablet', N'Twice daily', 90, 180, N'For heart rate control. Take with food.', 3, 0),
    (8, @levothyroxine100, N'Levothyroxine 100mcg', N'1 tablet', N'Once daily on empty stomach', 90, 90, N'Take 30-60 minutes before breakfast. Do not take with calcium or iron.', 3, 2),
    (9, @tretinoin, N'Tretinoin 0.025% cream', N'Pea-sized amount', N'Apply once daily at bedtime', 60, 1, N'Apply to dry skin. Use sunscreen daily. May cause initial dryness.', 2, 0),
    (10, @omeprazole20, N'Omeprazole 20mg', N'1 capsule', N'Once daily before breakfast', 30, 30, N'Take 30 minutes before first meal. Swallow whole, do not crush.', 2, 0);
GO

-- ============================================================================
-- SECTION 15: LAB RESULTS (uses record_id 1-10)
-- ============================================================================

INSERT INTO ohc.lab_result (record_id, test_name, test_code, result_value, unit, reference_range, is_abnormal, notes, tested_at) VALUES
    (2, N'Fasting Glucose', 'GLU', '142', 'mg/dL', '70-100', 1, N'Elevated - consistent with diabetes', DATEADD(DAY, -8, GETDATE())),
    (2, N'HbA1c', 'A1C', '7.2', '%', '<5.7', 1, N'Indicates diabetes, fair control', DATEADD(DAY, -8, GETDATE())),
    (2, N'Creatinine', 'CREAT', '1.1', 'mg/dL', '0.7-1.3', 0, N'Normal kidney function', DATEADD(DAY, -8, GETDATE())),
    (2, N'Total Cholesterol', 'CHOL', '198', 'mg/dL', '<200', 0, N'Borderline, improved from 235', DATEADD(DAY, -8, GETDATE())),
    (2, N'LDL Cholesterol', 'LDL', '118', 'mg/dL', '<100', 1, N'Slightly elevated', DATEADD(DAY, -8, GETDATE())),
    (2, N'HDL Cholesterol', 'HDL', '48', 'mg/dL', '>40', 0, N'Acceptable', DATEADD(DAY, -8, GETDATE())),
    (5, N'Troponin I', 'TROP', '<0.01', 'ng/mL', '<0.04', 0, N'Normal - no acute damage', DATEADD(DAY, -6, GETDATE())),
    (5, N'BNP', 'BNP', '85', 'pg/mL', '<100', 0, N'No heart failure', DATEADD(DAY, -6, GETDATE())),
    (5, N'Total Cholesterol', 'CHOL', '165', 'mg/dL', '<200', 0, N'Well controlled on statin', DATEADD(DAY, -6, GETDATE())),
    (5, N'LDL Cholesterol', 'LDL', '72', 'mg/dL', '<70', 1, N'Near goal for cardiac patient', DATEADD(DAY, -6, GETDATE())),
    (6, N'INR', 'INR', '2.4', 'ratio', '2.0-3.0', 0, N'Therapeutic range for AFib', DATEADD(DAY, -6, GETDATE())),
    (6, N'PT', 'PT', '28.5', 'seconds', '11-13.5', 1, N'Expected on warfarin', DATEADD(DAY, -6, GETDATE())),
    (8, N'TSH', 'TSH', '2.1', 'mIU/L', '0.4-4.0', 0, N'Well controlled', DATEADD(DAY, -5, GETDATE())),
    (8, N'Free T4', 'FT4', '1.2', 'ng/dL', '0.8-1.8', 0, N'Normal', DATEADD(DAY, -5, GETDATE())),
    (1, N'Complete Blood Count', 'CBC', 'WNL', 'N/A', 'N/A', 0, N'All values within normal limits', DATEADD(DAY, -8, GETDATE())),
    (1, N'Comprehensive Metabolic Panel', 'CMP', 'WNL', 'N/A', 'N/A', 0, N'All values within normal limits', DATEADD(DAY, -8, GETDATE())),
    (1, N'Lipid Panel', 'LIPID', 'WNL', 'N/A', 'N/A', 0, N'All values within normal limits', DATEADD(DAY, -8, GETDATE()));
GO

-- ============================================================================
-- SECTION 16: ACCESS LOGS
-- ============================================================================

INSERT INTO ohc.access_log (user_id, action_type, action_detail, table_name, record_id, ip_address, status, created_at) VALUES
    (12, 'login_success', N'Administrator logged in', NULL, NULL, '192.168.1.100', 'success', DATEADD(DAY, -7, GETDATE())),
    (12, 'user_created', N'Created new patient account', 'user_account', 13, '192.168.1.100', 'success', DATEADD(DAY, -7, GETDATE())),
    (1, 'login_success', N'Dr. Williams logged in', NULL, NULL, '192.168.1.101', 'success', DATEADD(DAY, -6, GETDATE())),
    (1, 'record_viewed', N'Viewed patient medical history', 'medical_record', 2, '192.168.1.101', 'success', DATEADD(DAY, -6, GETDATE())),
    (1, 'record_created', N'Created medical record', 'medical_record', 5, '192.168.1.101', 'success', DATEADD(DAY, -5, GETDATE())),
    (1, 'prescription_created', N'New prescription added', 'prescription', 4, '192.168.1.101', 'success', DATEADD(DAY, -5, GETDATE())),
    (2, 'login_success', N'Dr. Johnson logged in', NULL, NULL, '192.168.1.102', 'success', DATEADD(DAY, -6, GETDATE())),
    (2, 'record_created', N'Created medical record', 'medical_record', 3, '192.168.1.102', 'success', DATEADD(DAY, -6, GETDATE())),
    (5, 'login_success', N'Dr. Anderson logged in', NULL, NULL, '192.168.1.105', 'success', DATEADD(DAY, -7, GETDATE())),
    (5, 'record_created', N'Created medical record', 'medical_record', 1, '192.168.1.105', 'success', DATEADD(DAY, -7, GETDATE())),
    (10, 'login_success', N'Receptionist logged in', NULL, NULL, '192.168.1.110', 'success', DATEADD(DAY, -5, GETDATE())),
    (10, 'appointment_created', N'Scheduled new appointment', 'appointment', 14, '192.168.1.110', 'success', DATEADD(DAY, -5, GETDATE())),
    (10, 'appointment_updated', N'Confirmed appointment', 'appointment', 15, '192.168.1.110', 'success', DATEADD(DAY, -4, GETDATE())),
    (13, 'login_success', N'Patient logged in', NULL, NULL, '10.0.0.50', 'success', DATEADD(DAY, -3, GETDATE())),
    (13, 'appointment_viewed', N'Viewed upcoming appointments', 'appointment', NULL, '10.0.0.50', 'success', DATEADD(DAY, -3, GETDATE())),
    (NULL, 'login_failed', N'Invalid username: hacker123', NULL, NULL, '45.33.22.11', 'failure', DATEADD(DAY, -2, GETDATE())),
    (NULL, 'login_failed', N'Invalid password for user: admin.moore', NULL, NULL, '45.33.22.11', 'failure', DATEADD(DAY, -2, GETDATE())),
    (1, 'login_success', N'Dr. Williams logged in', NULL, NULL, '192.168.1.101', 'success', DATEADD(HOUR, -2, GETDATE())),
    (10, 'login_success', N'Receptionist logged in', NULL, NULL, '192.168.1.110', 'success', DATEADD(HOUR, -1, GETDATE()));
GO

-- ============================================================================
-- VERIFICATION
-- ============================================================================

PRINT N'============================================';
PRINT N'DATA INSERTION COMPLETE';
PRINT N'============================================';

SELECT 'Persons' AS entity, COUNT(*) AS count FROM ohc.person
UNION ALL SELECT 'Appointments', COUNT(*) FROM ohc.appointment
UNION ALL SELECT 'Medical Records', COUNT(*) FROM ohc.medical_record
UNION ALL SELECT 'Prescriptions', COUNT(*) FROM ohc.prescription
UNION ALL SELECT 'Vital Signs', COUNT(*) FROM ohc.vital_signs
UNION ALL SELECT 'Lab Results', COUNT(*) FROM ohc.lab_result
UNION ALL SELECT 'Access Logs', COUNT(*) FROM ohc.access_log;

SELECT status, COUNT(*) AS count 
FROM ohc.appointment 
GROUP BY status;

PRINT N'Sample data ready!';
GO